//
//  Day17.swift
//  Day17_2017
//
//  Created by Ivan Welsh on 06/05/2024.
//

import Foundation


@main final class Today: Day {
    init() { super.init(day: 17, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let N = 324
        var lock = [0]
        lock.reserveCapacity(50_000_000)
        var currentPos = 0
        for i in 1...2017 {
            let delta = (i + N) % lock.count
            currentPos = (currentPos + delta) % lock.count
            lock.insert(i, at: currentPos + 1)
            currentPos += 1
        }
        print("After 2017 iterations, value after 2017 is \(lock[(currentPos + 1) % lock.count])")
        
        currentPos = 0
        var after0 = 0
        for i in 1...50_000_000 {
            let insertPos = (i + N + currentPos) % i
            if insertPos == 0 { after0 = i }
            currentPos = insertPos + 1
        }
        print("After 50,000,000 iterations, value after 0 is \(after0)")
        
    }
    
    static func main() { Today().run() }
}
