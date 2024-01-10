#if os(iOS)
import UIKit

public protocol ErrorHandler {
    func handle(error: Error,
                okAction: (() -> Void)?,
                retryAction: (() -> Void)?,
                helpAction: (() -> Void)?)
}

public extension ErrorHandler where Self: UIViewController {
    func handle(error: Error,
                okAction: (() -> Void)? = nil,
                retryAction: (() -> Void)? = nil,
                helpAction: (() -> Void)? = nil) {
        
        var actions = [UIAlertAction]()
        
        if let okAction = okAction {
            actions.append(.init(title: "OK", style: .default, handler: { _ in okAction() } ))
        }
        
        if let retryAction = retryAction {
            actions.append(.init(title: "Retry", style: .default, handler: { _ in retryAction() } ))
        }
        
        if let helpAction = helpAction {
            actions.append(.init(title: "Help", style: .default, handler: { _ in helpAction() } ))
        }
        
        let alert = UIAlertController.error(error, actions: actions)
        
        self.present(alert, animated: true)
    }
}
#endif
