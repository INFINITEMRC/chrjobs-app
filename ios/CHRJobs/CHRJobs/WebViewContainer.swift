import SwiftUI
import WebKit
import CoreLocation

struct WebViewContainer: UIViewRepresentable {
    let url: URL
    var onPageFinished: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(onPageFinished: onPageFinished)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.websiteDataStore = .default()

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = preferences

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic

        context.coordinator.attachLocationIfNeeded()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.onPageFinished = onPageFinished
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, CLLocationManagerDelegate {
        var onPageFinished: (() -> Void)?
        private let locationManager = CLLocationManager()
        private var geolocationCompletion: ((CLLocationCoordinate2D?) -> Void)?

        init(onPageFinished: (() -> Void)?) {
            self.onPageFinished = onPageFinished
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }

        func attachLocationIfNeeded() {
            // Request when the site asks for geolocation via JS.
        }

        // MARK: - Navigation (parity with Android handleExternalUrl)

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            if shouldOpenExternally(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onPageFinished?()
        }

        /// Mirrors Android MainActivity.handleExternalUrl — only special schemes leave the WebView.
        private func shouldOpenExternally(_ url: URL) -> Bool {
            let scheme = (url.scheme ?? "").lowercased()
            if ["tel", "mailto", "sms", "whatsapp", "geo", "itms-apps", "itms"].contains(scheme) {
                return true
            }

            let absolute = url.absoluteString.lowercased()
            if absolute.hasPrefix("https://wa.me/") ||
                absolute.hasPrefix("https://api.whatsapp.com/") ||
                absolute.hasPrefix("https://chat.whatsapp.com/") {
                return true
            }

            return false
        }

        // MARK: - New windows / target=_blank

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
                if shouldOpenExternally(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    webView.load(navigationAction.request)
                }
            }
            return nil
        }

        // MARK: - Geolocation (iOS 15+)

        @available(iOS 15.0, *)
        func webView(
            _ webView: WKWebView,
            requestGeolocationPermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
        ) {
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                decisionHandler(.grant)
            case .notDetermined:
                geolocationCompletion = { _ in }
                locationManager.requestWhenInUseAuthorization()
                decisionHandler(.grant)
            default:
                decisionHandler(.deny)
            }
        }

        // MARK: - JS alerts

        func webView(
            _ webView: WKWebView,
            runJavaScriptAlertPanelWithMessage message: String,
            initiatedByFrame frame: WKFrameInfo,
            completionHandler: @escaping () -> Void
        ) {
            guard let controller = topViewController() else {
                completionHandler()
                return
            }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler() })
            controller.present(alert, animated: true)
        }

        func webView(
            _ webView: WKWebView,
            runJavaScriptConfirmPanelWithMessage message: String,
            initiatedByFrame frame: WKFrameInfo,
            completionHandler: @escaping (Bool) -> Void
        ) {
            guard let controller = topViewController() else {
                completionHandler(false)
                return
            }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Annuler", style: .cancel) { _ in completionHandler(false) })
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) })
            controller.present(alert, animated: true)
        }

        private func topViewController() -> UIViewController? {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let window = scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
            var top = window?.rootViewController
            while let presented = top?.presentedViewController {
                top = presented
            }
            return top
        }
    }
}
