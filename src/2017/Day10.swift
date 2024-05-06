//
//  Day10.swift
//  Day10_2017
//
//  Created by Ivan Welsh on 6/02/24.
//

import Foundation

func twistHash(using lengths: [Int], iterations: Int, n: Int = 256) -> [Int] {
    var circularList = Array(0..<n)
    var currentPosition = 0
    var skipAmount = 0
    
    for _ in 0..<iterations {
        for length in lengths {
            var startPosition = currentPosition
            var endPosition = (startPosition + length - 1) % n
            for _ in 0..<(length/2) {
                circularList.swapAt(startPosition, endPosition)
                endPosition -= 1
                if endPosition < 0 { endPosition = n - 1 }
                startPosition += 1
                if startPosition == n { startPosition = 0 }
                if endPosition == startPosition { break }
            }
            currentPosition = (currentPosition + skipAmount + length) % n
            skipAmount += 1
        }
    }
    return circularList
}

@main final class Today: Day {
    init() { super.init(day: 10, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let data = "129,154,49,198,200,133,97,254,41,6,2,1,255,0,191,108"
        let lengths = data.components(separatedBy: ",").map{ Int($0)! }
        let hash = twistHash(using: lengths, iterations: 1)
        print("Product of first two values is \(hash[0] * hash[1])")
        
        let asciiLengths = data.unicodeScalars.map{ Int($0.value) } + [17, 31, 73, 47, 23]
        let sparseHash = twistHash(using: asciiLengths, iterations: 64)
        var denseHash = [String]()
        for i in stride(from: 0, to: sparseHash.count, by: 16) {
            var val = sparseHash[i]
            for j in 1..<16 { val ^= sparseHash[i + j] }
            denseHash.append(String(format: "%02x", val))
        }
        print("Hash of input is \(denseHash.joined())")
        
    }
    
    static func main() { Today().run() }
}
