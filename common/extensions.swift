//
//  common.swift
//
//
//  Created by Ivan Welsh on 11/01/24.
//

import Foundation
import CryptoKit

extension String {
    func trimmed() -> String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    func md5() -> String {
        if let data = self.data(using: .utf8) {
            let hash = Insecure.MD5.hash(data: data)
            return hash.map { String(format: "%02hhx", $0) }.joined()
        }
        return ""
    }
    
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
    
    
}

extension Collection where Element: AdditiveArithmetic {
    func sum() -> Element { return reduce(Element.zero, { $0 + $1 }) }
}

extension Array {
    public func splat() -> (Element,Element) {
        return (self[0],self[1])
    }
    
    public func splat() -> (Element,Element,Element) {
        return (self[0],self[1],self[2])
    }
    
    public func splat() -> (Element,Element,Element,Element) {
        return (self[0],self[1],self[2],self[3])
    }
    
    public func splat() -> (Element,Element,Element,Element,Element) {
        return (self[0],self[1],self[2],self[3],self[4])
    }
}

extension Collection {
    var isNotEmpty: Bool {
        get { return !isEmpty }
    }
}
