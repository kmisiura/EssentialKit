#if os(iOS)
import UIKit

public extension Environment {
    static var isNotificationEnabled: Bool {
        UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    static var isAppRunningTest: Bool {
        ProcessInfo.processInfo.environment["APP_IS_RUNNING_TEST"] == "YES"
    }
}
#endif
