//
//  Array+Split
//  
//
//  Created by Karolis Misiūra on 2020-09-17.
//

import Foundation

public extension Array {
    
    ///  Converts an array into an array of arrays, using whatever size you specify.
    ///
    /// - Parameter size: of the array chunk
    /// - Returns: Splited array
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
