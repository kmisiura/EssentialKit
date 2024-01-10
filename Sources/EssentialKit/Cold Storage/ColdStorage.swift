import Combine
import Foundation
import OSLogger

public class ColdStorage {
    
    let name: String
    let path: URL
    let ioQueue: DispatchQueue
    
    public init(name: String) {
        precondition(name.length > 3, "Storage name cannot be shorter then 4 characters.")
        self.name = name
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            preconditionFailure("Cannot continue without bundle identifier.")
        }
        guard var appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            preconditionFailure("Cannot continue without application support directory.")
        }
        
        appSupportURL.appendPathComponent(bundleId, isDirectory: true)
        appSupportURL.appendPathComponent(name, isDirectory: true)
        
        do {
            try FileManager.default.createDirectory(at: appSupportURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            Log.error("Failed to create app support directory with error \(String(reflecting: error))")
            Log.critical("Could not create storage directory in application support directory.")
            fatalError("Could not create storage directory in application support directory.")
        }
        
        self.path = appSupportURL
        self.ioQueue = DispatchQueue(label: bundleId + ".StorageIO." + "name",
                                     qos: .utility)
    }
    
    public func write(data: Data, key: String, options: Data.WritingOptions) -> AnyPublisher<Void, Error> {
        return Future<Void, Error>.init { [weak self] completion in
            guard let self = self else { return }
            let url = self.path.appendingPathComponent(key)
            self.ioQueue.async {
                do {
                    try data.write(to: url, options: options)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func read(key: String) -> AnyPublisher<Data, Error> {
        return Future<Data, Error>.init { [weak self] completion in
            guard let self = self else { return }
            let url = self.path.appendingPathComponent(key)
            self.ioQueue.async {
                do {
                    let data = try Data(contentsOf: url)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func remove(key: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error>.init { [weak self] completion in
            guard let self = self else { return }
            let url = self.path.appendingPathComponent(key)
            self.ioQueue.async {
                do {
                    try FileManager.default.removeItem(at: url)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func destroy() -> AnyPublisher<Void, Error> {
        return Future<Void, Error>.init { [weak self] completion in
            guard let self = self else { return }
            self.ioQueue.async {
                do {
                    try FileManager.default.removeItem(at: self.path)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

@available(macOS 11.0, *)
public extension ColdStorage {
    func writeString(_ string: String, key: String, protected: Bool = false) -> AnyPublisher<Void, Error> {
        guard let data = string.data(using: .utf8) else {
            return Fail<Void, Error>.init(error: MKError.general(description: "Cannot write string",
                                                                    reason: "Failed to encode string into data.")).eraseToAnyPublisher()
        }
        
        return write(data: data, key: key, options: protected ? [.completeFileProtection] : [.noFileProtection])
    }
    
    func readString(_ key: String) -> AnyPublisher<String, Error> {
        return read(key: key).tryMap({ data in
            guard let string = String(data: data, encoding: .utf8) else {
                throw MKError.general(description: "Cannot to read string",
                                         reason: "Failed to decode data into string.")
            }
            return string
        }).eraseToAnyPublisher()
    }
}
