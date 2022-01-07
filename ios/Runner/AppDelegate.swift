import UIKit
import Flutter
import GoogleMaps
import Firebase

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    GeneratedPluginRegistrant.register(with: registry)
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
 FirebaseApp.configure() 
    GMSServices.provideAPIKey("AIzaSyB0oMSYks73MwXluaDyBXqG9u_SCaCFs-I")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
