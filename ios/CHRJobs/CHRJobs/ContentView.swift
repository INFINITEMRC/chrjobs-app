import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @EnvironmentObject private var adManager: AdManager

    var body: some View {
        VStack(spacing: 0) {
            WebViewContainer(url: AdConfig.startURL) {
                adManager.onPageFinished()
            }

            if let banner = adManager.bannerView {
                let height = banner.adSize.size.height
                BannerAdView(banner: banner)
                    .frame(maxWidth: .infinity)
                    .frame(height: height > 0 ? height : 50)
                    .background(Color(.systemBackground))
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BannerAdView: UIViewRepresentable {
    let banner: BannerView

    func makeUIView(context: Context) -> BannerView {
        banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}

#Preview {
    ContentView()
        .environmentObject(AdManager())
}
