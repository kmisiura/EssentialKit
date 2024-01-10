import Combine
import Foundation
import OSLogger

public extension Publisher {
    func retryWithDelay<T, E>(count: Int = 3,
                              delay: TimeInterval = 3.0) -> AnyPublisher<Output, Failure> where T == Self.Output, E == Self.Failure {
        return retryWithDelay(1, count: count, delay: delay)
    }
    
    private func retryWithDelay<T, E>(_ currentAttempt: UInt,
                                      count: Int,
                                      delay: TimeInterval) -> AnyPublisher<Output, Failure> where T == Self.Output, E == Self.Failure {
        
        guard currentAttempt > 0 else { return Empty<Output, Failure>().eraseToAnyPublisher() }
        
        return self.catch { error -> AnyPublisher<T, E> in
            
            let exponentialDelay: TimeInterval = TimeInterval(UInt(delay) ^ currentAttempt)
            
            Log.debug(String(describing: self) + " failed, will retrying in \(exponentialDelay) seconds.")
            
            guard currentAttempt <= count else {
                Log.debug(String(describing: self) + " failed after \(currentAttempt) retries, with error: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return Just(())
                .setFailureType(to: E.self)
                .delay(for: .seconds(exponentialDelay), scheduler: DispatchQueue.main)
                .flatMap { self.retryWithDelay(currentAttempt + 1, count: count, delay: delay) }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
