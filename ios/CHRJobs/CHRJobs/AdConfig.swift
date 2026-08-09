import Foundation

/// AdMob configuration for the iOS app.
enum AdConfig {
    /// AdMob App ID — must match Info.plist GADApplicationIdentifier
    static let applicationID = "ca-app-pub-8380240397159714~5556814087"

    /// CHR Banner (Android ID — create iOS units in AdMob for iOS app)
    static let bannerUnitID = "ca-app-pub-8380240397159714/5997735587"

    /// CHR Interstitial
    static let interstitialUnitID = "ca-app-pub-8380240397159714/8595978764"

    static let startURL = URL(string: "https://chrsd-ca487.web.app")!

    static let allowedHost = "chrsd-ca487.web.app"

    static let interstitialEveryNPages = 4
}