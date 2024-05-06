//
//  Day11.swift
//  Day11_2017
//
//  Created by Ivan Welsh on 6/02/24.
//

import Foundation

func distanceFromOrigin(of qrs: (q: Int, r: Int, s: Int)) -> Int {
    return max(abs(qrs.q), abs(qrs.r), abs(qrs.s))
}

@main final class Today: Day {
    init() { super.init(day: 11, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var hexLoc = (q: 0, r: 0, s: 0)
        var furtherestLoc = hexLoc
        for step in data.components(separatedBy: ",") {
            if step == "n" {
                hexLoc.s += 1
                hexLoc.r -= 1
            }
            if step == "ne" {
                hexLoc.q += 1
                hexLoc.r -= 1
            }
            if step == "se" { 
                hexLoc.q += 1
                hexLoc.s -= 1
            }
            if step == "s" {
                hexLoc.s -= 1
                hexLoc.r += 1
            }
            if step == "sw" {
                hexLoc.q -= 1
                hexLoc.r += 1
            }
            if step == "nw" { 
                hexLoc.q -= 1
                hexLoc.s += 1
            }
            if distanceFromOrigin(of: hexLoc) > distanceFromOrigin(of: furtherestLoc) {
                furtherestLoc = hexLoc
            }
        }
        print("Location of child is \(distanceFromOrigin(of: hexLoc))")
        print("Furtherest child got was \(distanceFromOrigin(of: furtherestLoc))")
    }
    
    static func main() { Today().run() }
}
