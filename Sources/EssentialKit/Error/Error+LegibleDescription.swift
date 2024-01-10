import Foundation

public extension Error {
    
    var legibleDescription: String {
        
        if let mkError = self as? MKError, case MKError.message(let message, let description) = mkError {
            return description != nil ? message + " \(description!)" : message
        }
        
        let nsError = self.nsError
        var errorText = ""
        if !nsError.localizedDescription.hasPrefix("The operation couldn’t be completed.") {
            errorText = nsError.localizedDescription
        } else if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? Error {
            errorText = underlyingError.legibleDescription
        } else {
            // usually better than the localizedDescription, but not pretty
            errorText = nsError.debugDescription
        }
        
        if let failureReason = nsError.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
            errorText.append("\n")
            errorText.append(failureReason)
        }
        
        return errorText
    }
}

public extension Error {
    var nsError: NSError {
        if let enumReflection = Mirror.reflectEnum(self) {
            var parameters = enumReflection.params
            let domain = enumReflection.parent
            let description: String
            let failureReason: String?
            let underlyingError: Error?
            let code: Int
            var userInfo: [String: Any] = ["ErrorName": enumReflection.label]
            
            /// Localized Description
            if let string = parameters["NSLocalizedDescription"] as? String {
                parameters.removeValue(forKey: "NSLocalizedDescription")
                description = string
            } else if let string = parameters["description"] as? String {
                parameters.removeValue(forKey: "description")
                description = string
            } else if let string = parameters["localizedDescription"] as? String {
                parameters.removeValue(forKey: "localizedDescription")
                description = string
            } else if let string = parameters["title"] as? String {
                parameters.removeValue(forKey: "title")
                description = string
            } else {
                description = enumReflection.label.camelCaseIntoSentence()
            }
            
            /// Error Code
            if let int = parameters["code"] as? Int {
                parameters.removeValue(forKey: "code")
                code = int
            } else if let pair = parameters.first(where: { $0.value is Int }), let int = pair.value as? Int {
                parameters.removeValue(forKey: pair.key)
                code = int
            } else {
                code = (self as NSError).code
            }
            
            /// Failure Reason
            if let string = parameters["detail"] as? String {
                parameters.removeValue(forKey: "detail")
                failureReason = string
            } else if let string = parameters["NSLocalizedFailureReason"] as? String {
                parameters.removeValue(forKey: "NSLocalizedFailureReason")
                failureReason = string
            } else if let string = parameters["failure"] as? String {
                parameters.removeValue(forKey: "failure")
                failureReason = string
            } else if let string = parameters["failureReason"] as? String {
                parameters.removeValue(forKey: "failureReason")
                failureReason = string
            } else if let string = parameters["reason"] as? String {
                parameters.removeValue(forKey: "reason")
                failureReason = string
            } else if let string = parameters["message"] as? String {
                parameters.removeValue(forKey: "message")
                failureReason = string
            } else if let pair = parameters.first(where: { $0.value is String }), let string = pair.value as? String {
                parameters.removeValue(forKey: pair.key)
                failureReason = string
            } else {
                failureReason = nil
            }
            
            /// Underlying Error
            if let error = parameters["NSUnderlyingError"] as? Error {
                parameters.removeValue(forKey: "NSUnderlyingError")
                underlyingError = error
            } else if let error = parameters["underlyingError"] as? Error {
                parameters.removeValue(forKey: "underlyingError")
                underlyingError = error
            } else if let error = parameters["error"] as? Error {
                parameters.removeValue(forKey: "error")
                underlyingError = error
            } else {
                underlyingError = nil
            }
            
            if let fr = failureReason { userInfo[NSLocalizedFailureReasonErrorKey] = fr }
            if let err = underlyingError { userInfo[NSUnderlyingErrorKey] = err }
            userInfo[NSLocalizedDescriptionKey] = description
            userInfo.merge(parameters, uniquingKeysWith: { (current, _) in current })
            
            return NSError(domain: domain,
                           code: code,
                           userInfo: userInfo)
        }
        
        return self as NSError
    }
}

private extension String {
    func camelCaseIntoSentence() -> String {
        var words = self.caseSplit().map { $0.lowercased() }
        guard !words.isEmpty else { return self }
        words[0] = words[0].capitalized
        return words.joined(separator: " ") + "."
    }
}
