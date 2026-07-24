import Foundation

/// AdMob configuration for the iOS app.
/// Create an iOS app in AdMob and replace the test unit IDs below with your real ones.
enum AdConfig {
    /// Shared AdMob app ID (same publisher). Must also be in Info.plist as GADApplicationIdentifier.
    /// After adding the iOS app in AdMob, replace with the iOS App ID if different.
    static let applicationID = "ca-app-pub-8380240397159714~5556814087"

    /// Google sample iOS banner (replace with your iOS Banner unit ID before App Store).
    static let bannerUnitID = "ca-app-pub-3940256099942544/2435281174"

    /// Google sample iOS interstitial (replace with your iOS Interstitial unit ID before App Store).
    static let interstitialUnitID = "ca-app-pub-3940256099942544/4411468910"

    /// Start URL loaded in the WebView (same as Android).
    static let startURL = URL(string: "https://chrsd-ca487.web.app")!

    /// Host allowed inside the WebView (everything else may open externally if scheme matches).
    static let allowedHost = "chrsd-ca487.web.app"

    /// Show an interstitial every N finished page loads.
    static let interstitialEveryNPages = 4
}
