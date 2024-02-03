//
//  Day22.swift
//  Day22_2016
//
//  Created by Ivan Welsh on 28/01/24.
//

import Foundation
import Collections

struct Node {
    let x: Int
    let y: Int
    let size: Int
    let used: Int
    let avail: Int
    let pct: Int
    
    init(from str: String) {
        let bits = str.split(separator: " ", omittingEmptySubsequences: true)
        let (_, x, y) = bits[0].components(separatedBy: "-").splat()
        self.x = Int(x[x.index(after: x.startIndex)...])!
        self.y = Int(y[y.index(after: y.startIndex)...])!
        self.size = Int(bits[1].components(separatedBy: "T").first!)!
        self.used = Int(bits[2].components(separatedBy: "T").first!)!
        self.avail = Int(bits[3].components(separatedBy: "T").first!)!
        self.pct = Int(bits[4].components(separatedBy: "%").first!)!
    }
}

enum AreaState {
    case immovable, empty, full, goal
}

typealias SlidingPuzzle = Array2D<AreaState>

extension SlidingPuzzle: Hashable, Equatable {
    static func == (lhs: Array2D, rhs: Array2D) -> Bool {
        lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) { data.hash(into: &hasher) }
    
    
}

@main final class Today: Day {
    init() { super.init(day: 22, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let data2 = """
/dev/grid/node-x0-y0   10T    8T     2T   80%
/dev/grid/node-x0-y1   11T    6T     5T   54%
/dev/grid/node-x0-y2   32T   28T     4T   87%
/dev/grid/node-x1-y0    9T    7T     2T   77%
/dev/grid/node-x1-y1    8T    0T     8T    0%
/dev/grid/node-x1-y2   11T    7T     4T   63%
/dev/grid/node-x2-y0   10T    6T     4T   60%
/dev/grid/node-x2-y1    9T    8T     1T   88%
/dev/grid/node-x2-y2    9T    6T     3T   66%
"""
        let nodes = data.components(separatedBy: "\n").map{ Node(from: $0) }
        
        var viablePairs = [(A: Int, B: Int)]()
        for A in 0..<nodes.count {
            if nodes[A].used == 0 { continue }
            for B in 0..<nodes.count {
                if A == B { continue }
                if nodes[A].used <= nodes[B].avail { viablePairs.append((A, B)) }
            }
        }
        print("There are \(viablePairs.count) viable pairs")
        
        var puzzle = SlidingPuzzle(columns: nodes.map{ $0.x }.max()! + 1,
                                   rows: nodes.map{ $0.y }.max()! + 1,
                                   fill: .immovable)
        for (a, _) in viablePairs {
            let node = nodes[a]
            puzzle[node.x, node.y] = .full
        }
        let startEmpty = nodes[viablePairs.first!.B]
        puzzle[startEmpty.x, startEmpty.y] = .empty
        // Set target
        puzzle[nodes.map{ $0.x }.max()!, 0] = .goal
        
        var potentialPuzzles = Deque([(puzzle: puzzle, steps: [(empty: Int, goal: Int)]())])
        var seenPuzzles = Set([[puzzle.firstIndex(of: .empty)!, puzzle.firstIndex(of: .goal)!]])
        while potentialPuzzles.first!.puzzle[0,0] != .goal {
            let (puzzle, steps) = potentialPuzzles.popFirst()!
            for nextState in moves(from: puzzle) {
                let key = [nextState.firstIndex(of: .empty)!, nextState.firstIndex(of: .goal)!]
                if seenPuzzles.contains(key) { continue }
                seenPuzzles.insert(key)
                potentialPuzzles.append((nextState, steps + [(key[0], key[1])]))
            }
        }
        print("Steps to get required data is \(potentialPuzzles.first!.steps.count)")
        
    }
    
    func moves(from puzzle: SlidingPuzzle) -> [SlidingPuzzle] {
        var nbrs = [SlidingPuzzle]()
        let idx = puzzle.firstIndex(of: .empty)!
        let (x, y) = puzzle.getXY(from: idx)
        for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            if x + dx < 0 || x + dx >= puzzle.columns { continue }
            if y + dy < 0 || y + dy >= puzzle.rows { continue }
            let idx2 = (y + dy) * puzzle.columns + (x + dx)
            if puzzle.data[idx2] == .immovable { continue }
            nbrs.append(puzzle)
            nbrs[nbrs.count - 1].data.swapAt(idx, idx2)
        }
        
        return nbrs
    }
    
    static func main() { Today().run() }
}
