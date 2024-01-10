import Foundation

public extension URL {
    mutating func appendQueryItems(_ items: [String: String?]) {
        if let newUrl = self.appendingQueryItems(items) {
            self = newUrl
        }
    }
    
    func appendingQueryItems(_ items: [String: String?]) -> URL? {
        guard let urlComponents = NSURLComponents(url: self, resolvingAgainstBaseURL: false) else {
            NSException(name: NSExceptionName.internalInconsistencyException,
                        reason: "Failed to generate NSURLComponents",
                        userInfo: ["url": self]).raise()
            return nil
        }
        
        var queryItems = urlComponents.queryItems ?? []
        for item in items {
            queryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let newUrl = urlComponents.url else {
            NSException(name: NSExceptionName.internalInconsistencyException,
                        reason: "Failed to generate new url.",
                        userInfo: ["url": self,
                                   "queryItems": items]).raise()
            return nil
        }
        
        return newUrl
    }
}
