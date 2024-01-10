import Foundation

public enum MKError: Error {
    case message(String, description: String? = nil)
    case general(description: String, reason: String?, error: Error? = nil)
    case retry(errorHandler: MKError.ErrorHandler)
    case osError(code: Int, description: String?)
}

public extension MKError {
    struct ErrorHandler: RecoverableError {
        public typealias Action = (title: String, action: () -> Bool)
        public let title: String
        public let message: String
        public let actions: [Action]
        
        public init(title: String,
                    message: String,
                    actions: [Action]) {
            self.title = title
            self.message = message
            self.actions = actions
        }
        
        public var recoveryOptions: [String] {
            return self.actions.map { $0.title }
        }
        
        public func attemptRecovery(optionIndex recoveryOptionIndex: Int) -> Bool {
            return actions[recoveryOptionIndex].action()
        }
        
        public func attemptRecovery(optionIndex recoveryOptionIndex: Int, resultHandler handler: @escaping (_ recovered: Bool) -> Void) {
            handler(actions[recoveryOptionIndex].action())
        }
    }
}

extension OSStatus {
    var info: (code: Int, description: String?)? {
        if self == noErr { return nil }
                
        if let message = SecCopyErrorMessageString(self, nil) {
            let description: String = message as String
            return (code: Int(self), description: description)
        }
        
        return (code: Int(self), description: nil)
    }
    
    var mkError: MKError? {
        guard let info = self.info else { return nil }
        return MKError.osError(code: info.code, description: info.description)
    }
}
