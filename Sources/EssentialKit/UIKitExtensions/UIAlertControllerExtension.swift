#if os(iOS)
import CoreNetwork
import UIKit

public extension UIAlertController {

    static func alert(title: String?, message: String? = nil, actions: QuickAction...) -> UIAlertController {
        let alertActions = actions.map({ action in
            return UIAlertAction(title: action.name, style: .default, handler: { _ in action.handler?() })
        })
        return self.alert(title: title, message: message, actions: alertActions)
    }
    
    static func alert(title: String?, message: String? = nil, actions: [UIAlertAction] = []) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.isEmpty {
            alertController.addAction(.init(title: "OK", style: .default, handler: nil))
        } else {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        return alertController
    }
    
    static func error(_ theError: Error, actions: [UIAlertAction] = []) -> UIAlertController {
        
        let error: Error
        let title: String
        let message: String
        let actions: [UIAlertAction]
        
        if case CoreNetworkError.backend(code: _, error: let backendError) = theError, let backendError = backendError {
            error = backendError
        } else if case CoreNetworkError.network(error: let networkError) = theError {
            error = networkError
        } else {
            error = theError
        }
        
        // TODO: Add handling for server error model.
        if case MKError.message(let errorMessage, let description) = error {
            title = description != nil ? errorMessage : "The operation couldn’t be completed"
            message = description ?? errorMessage
            actions = []
        } else if case MKError.retry(errorHandler: let handler) = error {
            title = handler.title
            message = handler.message
            actions = handler.actions.map({ action in
                let actionHandler = action.action
                return UIAlertAction.init(title: action.title, style: .default, handler: { _ in _ = actionHandler() })
            })
        } else {
            let nsError = error.nsError
            if let failureReason = nsError.localizedFailureReason {
                title = nsError.localizedDescription
                message = failureReason
            } else {
                title = "The operation couldn’t be completed"
                message = nsError.localizedDescription
            }
            
            if let recoverableError = self as? RecoverableError {
                actions = recoverableError.recoveryOptions.enumerated().map { enumerated in
                    let index = enumerated.offset
                    return UIAlertAction.init(title: enumerated.element,
                                              style: .default,
                                              handler: { _ in _ = recoverableError.attemptRecovery(optionIndex: index) })
                }
            } else {
                actions = []
            }
        }
        
        return UIAlertController.alert(title: title, message: message, actions: actions)
    }
}

#endif
