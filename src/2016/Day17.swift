//
//  Day17.swift
//  Day17_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation
import Collections

struct Path {
    let path: String
    let x: Int
    let y: Int
    
    var length: Int { get { return path.count }}
    
    func neighbours(base: String) -> [Path] {
        let hash = "\(base)\(path)".md5()
        let openIndicators = "bcdef"
        var nbrs = [Path]()
        let i0 = hash.startIndex
        // Up
        if y > 0 && openIndicators.contains(hash[i0]) {
            nbrs.append(Path(path: path + "U", x: x, y: y - 1))
        }
        let i1 = hash.index(after: i0)
        // Down
        if y < 3 && openIndicators.contains(hash[i1]) {
            nbrs.append(Path(path: path + "D", x: x, y: y + 1))
        }
        let i2 = hash.index(after: i1)
        // Left
        if x > 0 && openIndicators.contains(hash[i2]) {
            nbrs.append(Path(path: path + "L", x: x - 1, y: y))
        }
        let i3 = hash.index(after: i2)
        // Right
        if x < 3 && openIndicators.contains(hash[i3]) {
            nbrs.append(Path(path: path + "R", x: x + 1, y: y))
        }
        return nbrs
    }
}

@main final class Today: Day {
    init() { super.init(day: 17, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let input = "dmypynyp"
        var paths = Deque([Path(path: "", x: 0, y: 0)])
        var foundFastest = false
        var longestPath = 0
        while paths.isNotEmpty {
            let path = paths.popFirst()!
            if path.x == 3 && path.y == 3 {
                if !foundFastest {
                    print("Fastest path is: \(path.path)")
                    foundFastest = true
                }
                if path.length > longestPath {
                    longestPath = path.length
                }
                continue
            }
            let nbrs = path.neighbours(base: input)
            paths.append(contentsOf: nbrs)
        }
        print("Longest path is \(longestPath)")
    }
    
    static func main() { Today().run() }
}
