import Foundation
import GoogleMobileAds
import UIKit

@MainActor
final class AdManager: NSObject, ObservableObject {
    @Published var bannerView: BannerView?
    @Published private(set) var interstitialReady = false

    private var interstitialAd: InterstitialAd?
    private var pageLoadCount = 0

    func loadBanner() {
        let width = UIScreen.main.bounds.width
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = AdConfig.bannerUnitID
        banner.rootViewController = topViewController()
        banner.load(Request())
        bannerView = banner
    }

    func loadInterstitial() {
        InterstitialAd.load(
            with: AdConfig.interstitialUnitID,
            request: Request()
        ) { [weak self] ad, error in
            Task { @MainActor in
                guard let self else { return }
                if let error {
                    print("Interstitial failed to load: \(error.localizedDescription)")
                    self.interstitialAd = nil
                    self.interstitialReady = false
                    return
                }
                self.interstitialAd = ad
                self.interstitialReady = ad != nil
                ad?.fullScreenContentDelegate = self
            }
        }
    }

    func onPageFinished() {
        pageLoadCount += 1
        guard pageLoadCount % AdConfig.interstitialEveryNPages == 0 else { return }
        showInterstitialIfReady()
    }

    private func showInterstitialIfReady() {
        guard let interstitialAd,
              let root = topViewController() else { return }
        interstitialAd.present(from: root)
    }

    private func topViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        let window = scenes
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        var top = window?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}

extension AdManager: FullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            interstitialAd = nil
            interstitialReady = false
            loadInterstitial()
        }
    }

    nonisolated func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        Task { @MainActor in
            interstitialAd = nil
            interstitialReady = false
            loadInterstitial()
        }
    }
}
