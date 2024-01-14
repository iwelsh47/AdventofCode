//
//  Day14.swift
//  Day14_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation

struct Reindeer {
    let name: String
    let speed: Int
    let runTime: Int
    let restTime: Int
    
    init(from description: String) {
        let bits = description.components(separatedBy: " ")
        self.name = bits[0]
        self.speed = Int(bits[3])!
        self.runTime = Int(bits[6])!
        self.restTime = Int(bits[13])!
    }
    
    func distanceAfter(seconds: Int) -> Int {
        let cycleTime = runTime + restTime
        let (cycles, partCycle) = seconds.quotientAndRemainder(dividingBy: cycleTime)
        return cycles * runTime * speed + min(partCycle, runTime) * speed
    }
}

@main final class Today: Day {
    init() { super.init(day: 14, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let reindeer = data.components(separatedBy: "\n").map({ Reindeer(from: $0)})
        let bestReindeer = reindeer.max(by: { $0.distanceAfter(seconds: 2503) < $1.distanceAfter(seconds: 2503)})!
        print("Furtherest reindeer is \(bestReindeer.name) covering \(bestReindeer.distanceAfter(seconds: 2503))")
        var leadCounts = [String: Int]()
        for t in 1...2503 {
            var bestDistance = 0
            var bestReindeer = [String()]
            for r in reindeer {
                let distance = r.distanceAfter(seconds: t)
                if distance > bestDistance {
                    bestDistance = distance
                    bestReindeer = [r.name]
                } else if distance == bestDistance {
                    bestReindeer.append(r.name)
                }
            }
            
            for r in bestReindeer { leadCounts[r, default: 0] += 1 }
        }
        let bestScore = leadCounts.max(by: { $0.value < $1.value })!
        print("Best scoring reindeer is \(bestScore.key) with a score of \(bestScore.value)")
    }
    
    static func main() { Today().run() }
}
