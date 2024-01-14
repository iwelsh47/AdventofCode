//
//  Day17.swift
//  Day17_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation
import Algorithms

@main final class Today: Day {
    init() { super.init(day: 17, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let containerSizes = [33, 14, 18, 20, 45, 35, 16, 35, 1, 13, 18, 13, 50, 44, 48, 6, 24, 41, 30, 42]
            .sorted()
        
        // Maximum number of containers needed
        var index = 0
        while containerSizes[0...index].reduce(0, {$0 + $1}) < 150 { index += 1 }
        let maxSize = index + 1
        
        // Minimum number of containers needed
        index = containerSizes.count - 1
        while containerSizes[index..<containerSizes.count].reduce(0, {$0 + $1}) < 150 { index -= 1 }
        let minSize = containerSizes.count - index
        
        var waysToFill = [Int: Int]()
        for combo in containerSizes.combinations(ofCount: minSize...maxSize) {
            if combo.reduce(0, {$0 + $1}) == 150 {
                waysToFill[combo.count, default: 0] += 1
            }
        }
        print("Number of ways to get 150 litres is \(waysToFill.values.reduce(0, {$0 + $1}))")
        
        let minBucketsNeeded = waysToFill.keys.min()!
        let maxBucketsNeeded = waysToFill.keys.max()!
        print("Number of ways to fill minimum number of buckets (\(minBucketsNeeded)) is \(waysToFill[minBucketsNeeded]!)")
        print("Number of ways to fill maximum number of buckets (\(maxBucketsNeeded)) is \(waysToFill[maxBucketsNeeded]!)")
    }
    
    static func main() { Today().run() }
}
