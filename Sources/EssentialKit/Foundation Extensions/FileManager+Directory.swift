import Foundation

public extension FileManager {
    
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func tempFolderURL() throws -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try self.createDirectory(at: url,
                                 withIntermediateDirectories: true,
                                 attributes: nil)
        return url
    }
    
    func tempFileURL(fileName: String? = nil) throws -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        try self.createDirectory(at: url,
                                 withIntermediateDirectories: true,
                                 attributes: nil)
        
        if let fileName = fileName {
            return url.appendingPathComponent(fileName, isDirectory: false)
        } else {
            return url.appendingPathComponent(UUID().uuidString, isDirectory: false)
        }
    }
}
