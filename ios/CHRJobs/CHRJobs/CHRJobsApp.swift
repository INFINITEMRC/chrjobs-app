import SwiftUI
import AppTrackingTransparency

@main
struct CHRJobsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var adManager = AdManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(adManager)
                .onAppear {
                    requestTrackingIfNeeded()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        adManager.loadBanner()
                        adManager.loadInterstitial()
                    }
                }
        }
    }

    private func requestTrackingIfNeeded() {
        guard #available(iOS 14, *) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
