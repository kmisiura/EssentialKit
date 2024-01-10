#if os(iOS)
import UIKit

public extension Environment {
    static func userProperties(uid: String,
                               userLoggedIn: Bool = false,
                               firebaseToken: String = "",
                               senderId: String = "",
                               projectId: String = "",
                               experiment: String = "") -> [String: Any] {
        return  ["locale": Environment.locale,
                 "timezone": Environment.timeZone,
                 "client_version": Environment.appVersion,
                 "os_version": Environment.osVersion,
                 "device_brand": "Apple",
                 "device_model": Environment.hardwareString,
                 "device_name": UIDevice.current.name,
                 "notifications_enabled": Environment.isNotificationEnabled,
                 "experiment": experiment,
                 "uid": uid,
                 "user_logged_in": userLoggedIn,
                 "firebaseToken": firebaseToken,
                 "senderId": senderId,
                 "projectId": projectId]
    }
}
#endif
