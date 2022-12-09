import UIKit
import Flutter
import GoogleMaps

//import background_locator
//
//func registerPlugins(registry: FlutterPluginRegistry) -> () {
//    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
//        GeneratedPluginRegistrant.register(with: registry)
//    }
//}
//

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBxMIupdGzYQM6yk1ix1xGhgIyPw_42wlI")
//    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.flutter.background.refresh"
     
    GeneratedPluginRegistrant.register(with: self)
//    BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
