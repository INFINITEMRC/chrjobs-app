import UIKit
import GoogleMobileAds

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Never start ads in SwiftUI App.init() — that can abort on iPad before a window exists.
        DispatchQueue.main.async {
            var startError: NSError?
            let started = ExceptionCatcher.run({
                MobileAds.shared.start()
            }, error: &startError)
            if !started {
                print("AdMob start skipped: \(startError?.localizedDescription ?? "unknown")")
            }
        }
        return true
    }
}
