#if os(iOS)
import UIKit

public protocol QuickAlerts {
    typealias QuickAction = (name: String, handler: (() -> Void)?)
    func showAlert(title: String?, message: String?)
    func showAlert(title: String?, message: String?, actions: QuickAction...)
    func showAlert(title: String?, message: String?, actions: [UIAlertAction])
}

extension UIViewController: QuickAlerts {
    public func showAlert(title: String?, message: String?) {
        self.showAlert(title: title, message: message, actions: [])
    }
    
    public func showAlert(title: String? = nil, message: String? = nil, actions: QuickAction...) {
        let alertActions = actions.map({ action in
            return UIAlertAction(title: action.name, style: .default, handler: { _ in action.handler?() })
        })
        self.showAlert(title: title, message: message, actions: alertActions)
    }
    
    public func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController.alert(title: title, message: message, actions: actions)
        self.present(alertController, animated: true, completion: nil)
    }
}
#endif
