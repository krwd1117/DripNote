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
                            print("❌ Failed to fetch ad unit ID: \(error)")
                        }
                    }
            } else {
                NativeAdRepresentableView(
                    adUnitID: adUnitID,
                    backgroundColor: backgroundColor
                )
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
            context.coordinator.loadAd(in: containerView)
            return containerView
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
        
        class NativeAdCoordinator: NSObject, NativeAdLoaderDelegate {
            var parent: NativeAdRepresentableView
            var adLoader: AdLoader?
            weak var containerView: UIView?
            
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
                
                let adLoader = AdLoader(
                    adUnitID: parent.adUnitID,
                    rootViewController: rootVC,
                    adTypes: [.native],
                    options: nil
                )
                adLoader.delegate = self
                self.adLoader = adLoader
                adLoader.load(Request())
            }
            
            func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
                guard let containerView = containerView else { return }
                containerView.subviews.forEach { $0.removeFromSuperview() }
                
                let nativeAdView = NativeAdView()
                nativeAdView.translatesAutoresizingMaskIntoConstraints = false
                nativeAdView.backgroundColor = UIColor(parent.backgroundColor)
                
                // Headline
                let headlineLabel = UILabel()
                headlineLabel.font = .boldSystemFont(ofSize: 16)
                headlineLabel.text = nativeAd.headline
                headlineLabel.translatesAutoresizingMaskIntoConstraints = false
                
                // Image
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                if let firstImage = nativeAd.images?.first as? NativeAdImage {
                    imageView.image = firstImage.image
                }
                
                // Icon
                let iconImageView = UIImageView()
                iconImageView.contentMode = .scaleAspectFit
                iconImageView.translatesAutoresizingMaskIntoConstraints = false
                if let icon = nativeAd.icon {
                    iconImageView.image = icon.image
                }
                
                // Body
                let bodyLabel = UILabel()
                bodyLabel.font = .systemFont(ofSize: 14)
                bodyLabel.text = nativeAd.body ?? ""
                bodyLabel.numberOfLines = 2
                bodyLabel.translatesAutoresizingMaskIntoConstraints = false
                
                // CTA
                let ctaButton = UIButton(type: .system)
                ctaButton.setTitle(nativeAd.callToAction ?? "더보기", for: .normal)
                ctaButton.backgroundColor = .systemBlue
                ctaButton.setTitleColor(.white, for: .normal)
                ctaButton.layer.cornerRadius = 5
                ctaButton.translatesAutoresizingMaskIntoConstraints = false
                nativeAdView.callToActionView = ctaButton
                ctaButton.isUserInteractionEnabled = false  // Google SDK가 제어하도록 설정
                
                [headlineLabel, imageView, iconImageView, bodyLabel, ctaButton].forEach {
                    nativeAdView.addSubview($0)
                }
                
                NSLayoutConstraint.activate([
                    headlineLabel.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 12),
                    headlineLabel.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 12),
                    headlineLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -12),
                    
                    imageView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8),
                    imageView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
                    imageView.heightAnchor.constraint(equalToConstant: 180),
                    
                    iconImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                    iconImageView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 12),
                    iconImageView.widthAnchor.constraint(equalToConstant: 40),
                    iconImageView.heightAnchor.constraint(equalToConstant: 40),
                    
                    bodyLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
                    bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                    bodyLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -12),
                    
                    ctaButton.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
                    ctaButton.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 12),
                    ctaButton.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -12),
                    ctaButton.heightAnchor.constraint(equalToConstant: 40),
                    
                    ctaButton.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -12)
                ])
                
                nativeAdView.nativeAd = nativeAd
                containerView.addSubview(nativeAdView)
                
                NSLayoutConstraint.activate([
                    nativeAdView.topAnchor.constraint(equalTo: containerView.topAnchor),
                    nativeAdView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    nativeAdView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    nativeAdView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
            }
            
            func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
                print("❌ 광고 로드 실패: \(error.localizedDescription)")
            }
        }
    }
}
