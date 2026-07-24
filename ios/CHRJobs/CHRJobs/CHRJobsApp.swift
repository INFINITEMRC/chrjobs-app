import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct CHRJobsApp: App {
    @StateObject private var adManager = AdManager()

    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(adManager)
                .onAppear {
                    requestTrackingIfNeeded()
                    adManager.loadBanner()
                    adManager.loadInterstitial()
                }
        }
    }

    private func requestTrackingIfNeeded() {
        guard #available(iOS 14, *) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
