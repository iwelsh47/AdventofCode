//
//  Day14.swift
//  Day14_2017
//
//  Created by Ivan Welsh on 05/05/2024.
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

func knotHash(of str: String) -> String {
    let sparseHash = twistHash(using: str.unicodeScalars.map{ Int($0.value) } + [17, 31, 73, 47, 23],
                               iterations: 64)
    var denseHash = [String]()
    for i in stride(from: 0, to: sparseHash.count, by: 16) {
        var val = sparseHash[i]
        for j in 1..<16 { val ^= sparseHash[i + j] }
        denseHash.append(String(format: "%02x", val))
    }
    return denseHash.joined()
}

class Hashgrid {
    var grid: Array2D<Int>
    struct Cell: Equatable { let col: Int; let row: Int }
    
    init(data: [String]) {
        grid = Array2D(columns: data.first?.count ?? 0,
                       rows: data.count)
        for (i, row) in data.enumerated() {
            for (j, col) in row.enumerated() {
                if col == "1" { grid[j, i] = 0 }
            }
        }
    }
    
    lazy var numGroups = assignGroups()
    
    func assignGroups() -> Int {
        var nextGroup = 1
        for row in 0..<grid.rows {
            for col in 0..<grid.columns {
                if grid[col, row] != 0 { continue }
                for cell in getGroupContaining(cell: Cell(col: col, row: row)) {
                    grid[cell.col, cell.row] = nextGroup
                }
                nextGroup += 1
            }
        }
        return nextGroup - 1
    }
    
    func getGroupContaining(cell: Cell) -> [Cell] {
        var toCheck = [cell]
        let checkVal = grid[cell.col, cell.row]
        if checkVal == nil { return [] }
        
        var group = [Cell]()
        var checked = [Cell]()
        while toCheck.isNotEmpty {
            let checking = toCheck.popLast()!
            group.append(checking)
            checked.append(checking)
            
            let nbrs = [Cell(col: checking.col + 1, row: checking.row),
                        Cell(col: checking.col - 1, row: checking.row),
                        Cell(col: checking.col, row: checking.row + 1),
                        Cell(col: checking.col, row: checking.row - 1)]
                .filter{ $0.col >= 0 && $0.col < grid.columns &&
                    $0.row >= 0 && $0.row < grid.rows &&
                    grid[$0.col, $0.row] == checkVal &&
                    !checked.contains($0) }
            toCheck.append(contentsOf: nbrs)
        }
        
        return group
    }
}

@main final class Today: Day {
    let charToBin: [Character : String] = ["0": "0000",
                                           "1": "0001",
                                           "2": "0010",
                                           "3": "0011",
                                           "4": "0100",
                                           "5": "0101",
                                           "6": "0110",
                                           "7": "0111",
                                           "8": "1000",
                                           "9": "1001",
                                           "a": "1010",
                                           "b": "1011",
                                           "c": "1100",
                                           "d": "1101",
                                           "e": "1110",
                                           "f": "1111"]
    let charToUsed : [Character : Int]
    init() {
        charToUsed = charToBin.mapValues{ $0.countInstances(of: "1") }
        super.init(day: 14, year: 2017)
    }
    
    
    
    override func run() {
        print("Running \(year), day \(day)")
        let data = "ljoxqyyw"
        var totalUsed = 0
        for i in 0..<128 {
            let hash = knotHash(of: "\(data)-\(i)")
            totalUsed += hash.map{ charToUsed[$0]! }.sum()
        }
        print("Total used cells of grid is \(totalUsed)")
        
        let gridData = (0..<128)
            .map{ knotHash(of: "\(data)-\($0)") }
            .map{ $0.map{ charToBin[$0]! }.joined() }
        var hashgrid = Hashgrid(data: gridData)
        print("Total number of groups is \(hashgrid.numGroups)")
        
    }
    
    static func main() { Today().run() }
}
