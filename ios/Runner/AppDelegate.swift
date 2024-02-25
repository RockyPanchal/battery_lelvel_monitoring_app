import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let backgroundTaskName = "com.example.batteryLevelMonitoringApp.battery_data_fetch"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      GeneratedPluginRegistrant.register(with: self)
      UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
      UNUserNotificationCenter.current().delegate = self

      WorkmanagerPlugin.setPluginRegistrantCallback { registry in
          // Registry in this case is the FlutterEngine that is created in Workmanager's
          // performFetchWithCompletionHandler or BGAppRefreshTask.
          // This will make other plugins available during a background operation.
          GeneratedPluginRegistrant.register(with: registry)
      }
      
      WorkmanagerPlugin.registerTask(withIdentifier: backgroundTaskName)
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler(.alert) // shows banner even if app is in foreground
     }
    
}
