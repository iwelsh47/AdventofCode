//
//  Day24.swift
//  Day24_2016
//
//  Created by Ivan Welsh on 3/02/24.
//

import Foundation
import Collections
import Algorithms

enum CellType { case wall, open, poi0, poi1, poi2, poi3, poi4, poi5, poi6, poi7, poi8, poi9 }

struct Maze {
    let cells: Array2D<CellType>
    
    func firstIndex(of val: CellType) -> Int? { cells.firstIndex(of: val) }
    func neighbours(of idx: Int) -> [Int] {
        var nbrs = [Int]()
        let (x, y) = cells.getXY(from: idx)
        for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            if dx + x < 0 || dx + x >= cells.columns { continue }
            if dy + y < 0 || dy + y >= cells.rows { continue }
            let nbrIdx = cells.getIdx(from: dx + x, and: dy + y)
            if cells.data[nbrIdx] == .wall { continue }
            nbrs.append(nbrIdx)
        }
        return nbrs
    }
    
    func getPointOfInterestLocations() -> [CellType: Int] {
        var locations = [CellType: Int]()
        for (idx, value) in cells.data.enumerated() {
            if value == .wall || value == .open { continue }
            locations[value!, default: 0] = idx
        }
        return locations
    }
    
    func shortestLength(from start: Int, to end: Int) -> Int {
        var cellsToCheck = Deque([(cell: start, path: [start])])
        var visitedCells = Set([start])
        
        while cellsToCheck.first!.cell != end {
            let (cell, path) = cellsToCheck.popFirst()!
            for nbr in neighbours(of: cell) {
                if visitedCells.contains(nbr) { continue }
                cellsToCheck.append((nbr, path + [nbr]))
                visitedCells.insert(nbr)
            }
        }
        
        return cellsToCheck.first!.path.count - 1
    }
    
    func travellingSalesman(returning: Bool = false) -> Int {
        let pointsOfInterest = getPointOfInterestLocations().map{ (cell: $0.key, idx: $0.value) }
        var point2pointDist = [CellType: [CellType: Int]]()
        for startIdx in 0..<pointsOfInterest.count {
            for endIdx in startIdx..<pointsOfInterest.count {
                let (startCell, startLoc) = pointsOfInterest[startIdx]
                let (endCell, endLoc) = pointsOfInterest[endIdx]
                let distance = shortestLength(from: startLoc, to: endLoc)
                point2pointDist[startCell, default: [CellType: Int]()][endCell, default: 0] = distance
                point2pointDist[endCell, default: [CellType: Int]()][startCell, default: 0] = distance
            }
        }
        var bestDist = Int.max
        for perm in pointsOfInterest.permutations(ofCount: pointsOfInterest.count) {
            if perm.first!.cell != .poi0 { continue }
            var dist = 0
            for idx in 0..<(perm.count - 1) {
                dist += point2pointDist[perm[idx].cell]![perm[idx + 1].cell]!
            }
            if returning { dist += point2pointDist[perm.last!.cell]![perm.first!.cell]! }
            
            if dist < bestDist { bestDist = dist }
        }
        return bestDist
    }
}

func generateMaze(from desc: String) -> Maze {
    let rows = desc.components(separatedBy: "\n")
    var maze = Array2D(columns: rows.first!.count, rows: rows.count, fill: CellType.open)
    for (y, row) in rows.enumerated() {
        for (x, char) in row.enumerated() {
            switch char {
                case "#": maze[x, y] = .wall
                case "0": maze[x, y] = .poi0
                case "1": maze[x, y] = .poi1
                case "2": maze[x, y] = .poi2
                case "3": maze[x, y] = .poi3
                case "4": maze[x, y] = .poi4
                case "5": maze[x, y] = .poi5
                case "6": maze[x, y] = .poi6
                case "7": maze[x, y] = .poi7
                case "8": maze[x, y] = .poi8
                case "9": maze[x, y] = .poi9
                default: continue
            }
        }
    }
    
    return Maze(cells: maze)
}

@main final class Today: Day {
    init() { super.init(day: 24, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let data2 = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"""
        let maze = generateMaze(from: data)
        print("Shortest allpoints path is \(maze.travellingSalesman())")
        print("Shortest allpoints returning path is \(maze.travellingSalesman(returning: true))")
        
    }
    
    static func main() { Today().run() }
}
