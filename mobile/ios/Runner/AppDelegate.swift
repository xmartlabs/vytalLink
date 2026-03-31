import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let deepLinkChannelName = "com.xmartlabs.vytallink/deep_links"
  private var deepLinkChannel: FlutterMethodChannel?
  private var pendingDeepLinks: [String] = []
  private var isFlutterReady = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: deepLinkChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handleDeepLinkChannelCall(call, result: result)
      }
      deepLinkChannel = channel
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    enqueueDeepLink(url)
    return super.application(app, open: url, options: options)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL else {
      return super.application(
        application,
        continue: userActivity,
        restorationHandler: restorationHandler
      )
    }

    enqueueDeepLink(url)
    return true
  }

  private func handleDeepLinkChannelCall(
    _ call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    switch call.method {
    case "activate":
      isFlutterReady = true
      result(pendingDeepLinks)
      pendingDeepLinks.removeAll()
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func enqueueDeepLink(_ url: URL) {
    let deepLink = url.absoluteString

    guard isFlutterReady, let channel = deepLinkChannel else {
      pendingDeepLinks.append(deepLink)
      return
    }

    channel.invokeMethod("onDeepLink", arguments: deepLink)
  }
}
