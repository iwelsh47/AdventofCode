//
//  Day09.swift
//  Day09_2015
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation
import Algorithms

struct WorldMap {
    var locations = [String: [String: Int]]()
    
    init(from distances: String) {
        for distance in distances.components(separatedBy: "\n") {
            let (path, rawDistance) = distance.components(separatedBy: " = ").splat()
            let (start, end) = path.components(separatedBy: " to ").splat()
            addDistance(from: start, to: end, distance: Int(rawDistance)!)
        }
    }
    
    mutating func addDistance(from start: String, to end: String, distance: Int) {
        if locations.keys.contains(start) {
            locations[start]?[end] = distance
        } else {
            locations[start] = [end: distance]
        }
        if locations.keys.contains(end) {
            locations[end]?[start] = distance
        } else {
            locations[end] = [start: distance]
        }
    }
}

@main final class Today: Day {
    init() { super.init(day: 9, year: 2015) }
    
    enum TargetType { case long, short }
    
    func findBestPath(in world: WorldMap, ofType: TargetType) -> (path: [String], distance: Int) {
        var bestPath = [String]()
        var bestDistance = ofType == .long ? Int.min : Int.max
        
        for path in world.locations.keys.permutations() {
            var pathDistance = 0
            for index in path.startIndex..<path.index(before: path.endIndex) {
                let start = path[index]
                let end = path[path.index(after: index)]
                pathDistance += world.locations[start]![end]!
            }
            if (ofType == .long && pathDistance > bestDistance) ||
                (ofType == .short && pathDistance < bestDistance) {
                bestDistance = pathDistance
                bestPath = path
            }
        }
        return (bestPath, bestDistance)
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let world = WorldMap(from: data)
        let shortResult = findBestPath(in: world, ofType: .short)
        print("Shortest path in the world is \(shortResult)")
        let longResult = findBestPath(in: world, ofType: .long)
        print("Longest path in the world is \(longResult)")
    }
    
    static func main() { Today().run() }
}
