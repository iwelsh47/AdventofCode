//
//  Day13.swift
//  Day13_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation
import Collections

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    
    func neighbours() -> [Coordinate] {
        var nbrs = [Coordinate]()
        for dx in [x + 1, x - 1] {
            if dx < 0 { continue }
            nbrs.append(Coordinate(x: dx, y: y))
        }
        for dy in [y + 1, y - 1] {
            if dy < 0 { continue }
            nbrs.append(Coordinate(x: x, y: dy))
        }
        return nbrs.filter({ $0.isOpen })
    }
    
    var isOpen: Bool {
        get {
            let prod = x * x + 3 * x + 2 * x * y + y + y * y + favNumber
            return prod.nonzeroBitCount.isMultiple(of: 2)
        }
    }
}

var favNumber = 1362
@main final class Today: Day {
    init() { super.init(day: 13, year: 2016) }
    
    func findPath(from start: Coordinate, to end: Coordinate) -> [Coordinate] {
        var visitedPoints = Set([start])
        var fifoStack = Deque([[start]])
        while fifoStack.first!.last! != end {
            let path = fifoStack.popFirst()!
            let nbrs = path.last!.neighbours().filter({ !visitedPoints.contains($0) })
            visitedPoints.formUnion(nbrs)
            for nbr in nbrs {
                if nbr == end { return path + [nbr] }
                fifoStack.append(path + [nbr])
            }
        }
        return fifoStack.popFirst()!
    }
    
    func findPoints(from start: Coordinate, distance: Int) -> Set<Coordinate> {
        struct CoordinateDisance: Hashable {
            let coord: Coordinate
            let distance: Int
        }
        var withinDistance = Set<Coordinate>([start])
        var fifoStack = Deque([CoordinateDisance(coord: start, distance: 0)])
        while fifoStack.isNotEmpty {
            let ptDist = fifoStack.popFirst()!
            if ptDist.distance == distance { continue }
            let nbrs = ptDist.coord.neighbours().filter({ !withinDistance.contains($0) })
            withinDistance.formUnion(nbrs)
            for nbr in nbrs {
                fifoStack.append(CoordinateDisance(coord: nbr, distance: ptDist.distance + 1))
            }
        }
        return withinDistance
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let path = findPath(from: Coordinate(x: 1, y: 1), to: Coordinate(x: 31, y: 39))
        print("Steps to get from (1,1) to (31,39) is \(path.count - 1)")
        let points = findPoints(from: Coordinate(x: 1, y: 1), distance: 50)
        print("Number of points with 50 steps is \(points.count)")
    }
    
    static func main() { Today().run() }
}
