import SwiftUI
import GoogleMobileAds

public struct BannerAdContainerView: View {
    @State private var adUnitID: String = ""
    private let unitID: UnitID
    private let backgroundColor: Color

    public init(unitID: UnitID, backgroundColor: Color = .clear) {
        self.unitID = unitID
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Group {
            if adUnitID.isEmpty {
                ProgressView()
                    .task {
                        do {
                            adUnitID = try await fetchRemoteConfig(type: unitID)
                        } catch {
                            print("❌ Failed to fetch banner ad unit ID: \(error)")
                        }
                    }
            } else {
                BannerAdRepresentableView(adUnitID: adUnitID)
                    .frame(height: 50)
                    .background(backgroundColor)
            }
        }
    }
}

private struct BannerAdRepresentableView: UIViewRepresentable {
    let adUnitID: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.rootViewController
        bannerView.delegate = context.coordinator
        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    class Coordinator: NSObject, BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("✅ 배너 광고 로드 완료")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("❌  : \(error.localizedDescription)")
        }
    }
}

private extension UIApplication {
    var rootViewController: UIViewController? {
        self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
