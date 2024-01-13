//
//  Day08.swift
//  Day08_2015
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation

extension String {
    var encodedCount: Int {
        get {
            var count = 0
            var index = self.index(after: self.startIndex)
            while index != self.index(before: self.endIndex) {
                let char = self[index]
                if char == "\\" {
                    let nextChar = self[self.index(after: index)]
                    switch nextChar {
                        case "\\": index = self.index(index, offsetBy: 2)
                        case "\"": index = self.index(index, offsetBy: 2)
                        case "x": index = self.index(index, offsetBy: 4)
                        default: index = self.index(after: index)
                    }
                } else {
                    index = self.index(after: index)
                }
                count += 1
            }
            return count
        }
    }
    
    var reencodedCount: Int {
        get {
            var count = 2 // leading and trailing double quotes
            for char in self {
                switch char {
                    case "\\": count += 2
                    case "\"": count += 2
                    default: count += 1
                }
            }
            return count
        }
    }
}

@main final class Today: Day {
    init() { super.init(day: 8, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let strings = data.components(separatedBy: "\n")
        let totalCodeCharacters = strings.reduce(0, {$0 + $1.count})
        let totalLength = strings.reduce(0, {$0 + $1.encodedCount})
        let totalReencoded = strings.reduce(0, {$0 + $1.reencodedCount})
        print("The requested difference is \(totalCodeCharacters - totalLength)")
        print("The requested difference after reencoding is \(totalReencoded - totalCodeCharacters)")
    }
    
    static func main() { Today().run() }
}
