import SwiftUI
import GoogleMobileAds

public struct NativeAdContainerView: View {
    @State private var adUnitID: String = ""
    private let backgroundColor: Color
    
    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        Group {
            if adUnitID.isEmpty {
                ProgressView()
                    .task {
                        do {
                            adUnitID = try await fetchRemoteConfig()
                        } catch {
                            print("Failed to fetch ad unit ID: \(error)")
                        }
                    }
            } else {
                NativeAdRepresentableView(adUnitID: adUnitID, backgroundColor: backgroundColor)
            }
        }
    }
    
    private struct NativeAdRepresentableView: UIViewRepresentable {
        private let adUnitID: String
        private let backgroundColor: Color
        
        init(adUnitID: String, backgroundColor: Color) {
            self.adUnitID = adUnitID
            self.backgroundColor = backgroundColor
        }
        
        func makeCoordinator() -> NativeAdCoordinator {
            NativeAdCoordinator(self)
        }
        
        func makeUIView(context: Context) -> UIView {
            let containerView = UIView(frame: .zero)
            containerView.backgroundColor = .clear
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            context.coordinator.loadAd(in: containerView)
            return containerView
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            // 업데이트 필요 시 처리
        }
        
        class NativeAdCoordinator: NSObject, NativeAdLoaderDelegate {
            var parent: NativeAdRepresentableView
            var adLoader: AdLoader?
            var containerView: UIView?
            var adDisplayView: UIView?
            
            init(_ parent: NativeAdRepresentableView) {
                self.parent = parent
                super.init()
            }
            
            func loadAd(in containerView: UIView) {
                self.containerView = containerView
                
                guard
                    let windowScene = UIApplication.shared
                        .connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                    let rootVC = windowScene.windows
                        .first(where: { $0.isKeyWindow })?.rootViewController
                else {
                    return
                }
                
                let adLoader = AdLoader(adUnitID: parent.adUnitID,
                                        rootViewController: rootVC,
                                        adTypes: [.native],
                                        options: nil)
                adLoader.delegate = self
                self.adLoader = adLoader
                adLoader.load(Request())
            }
            
            func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
                containerView?.subviews.forEach { $0.removeFromSuperview() }
                
                let adView = UIView()
                adView.backgroundColor = UIColor(parent.backgroundColor)
                
                let headlineLabel = UILabel()
                headlineLabel.font = .boldSystemFont(ofSize: 16)
                headlineLabel.text = nativeAd.headline
                headlineLabel.translatesAutoresizingMaskIntoConstraints = false
                
                adView.addSubview(headlineLabel)
                
                NSLayoutConstraint.activate([
                    headlineLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: 10),
                    headlineLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 10),
                    headlineLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -10)
                ])
                
                adView.frame = containerView?.bounds ?? CGRect(x: 0, y: 0, width: 320, height: 150)
                adView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                containerView?.addSubview(adView)
                self.adDisplayView = adView
            }
            
            func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
                print("❌ 광고 로드 실패: \(error.localizedDescription)")
            }
        }
    }
}
