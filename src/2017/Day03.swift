//
//  Day03.swift
//  Day03_2017
//
//  Created by Ivan Welsh on 4/02/24.
//

//     -4 -3 -2 -1  0 +1 +2 +3 +4 +5
//  +5 00 99 98 97 96 95 94 93 92 91
//  +4 65 64 63 62 61 60 59 58 57 90
//  +3 66 37 36 35 34 33 32 31 56 89
//  +2 67 38 17 16 15 14 13 30 55 88
//  +1 68 39 18  5  4  3 12 29 54 87
//   0 69 40 19  6  1  2 11 28 53 86
//  -1 70 41 20  7  8  9 10 27 52 85
//  -2 71 42 21 22 23 24 25 26 51 84
//  -3 72 43 44 45 46 47 48 49 50 83
//  -4 73 74 75 76 77 78 79 80 81 82
//
import Foundation

struct Coordinate: Hashable, Equatable {
    let x: Int
    let y: Int
    
    func neighbours() -> [Coordinate] {
        var nbrs = [Coordinate]()
        for dx in -1...1 {
            for dy in -1...1 {
                if dx == 0 && dy == 0 { continue }
                nbrs.append(Coordinate(x: x + dx, y: y + dy))
            }
        }
        return nbrs
    }
}

func location(of square: Int) -> Coordinate {
    let lowerSqrt = Int(floor(sqrt(Double(square))))
    var toAdd = square - lowerSqrt * lowerSqrt
    var startX: Int
    var startY: Int
    
    if lowerSqrt.isMultiple(of: 2) {
        startX =  1 - lowerSqrt / 2
        startY = lowerSqrt / 2
    } else {
        startX = lowerSqrt / 2
        startY = -(lowerSqrt - 1) / 2
    }
    
    if toAdd > lowerSqrt {
        if lowerSqrt.isMultiple(of: 2) {
            startY -= lowerSqrt
            startX -= 1
        } else {
            startY += lowerSqrt
            startX += 1
        }
        toAdd -= lowerSqrt + 1
    }
    if toAdd == 0 { return Coordinate(x: startX, y: startY) }
    
    if startX <= 0 && startY <= 0 { startX += toAdd }
    else if startX <= 0 && startY > 0 { startX -= 1; startY -= toAdd - 1 }
    else if startX > 0 && startY > 0 { startX -= toAdd }
    else if startX > 0 && startY <= 0 { startX += 1; startY += toAdd - 1 }
    
    return Coordinate(x: startX, y: startY)
}

func firstValueGreaterThan(target: Int) -> Int {
    var locationValues = [Coordinate(x: 0, y: 0): 1]
    var value = 1
    while value < target {
        let loc = location(of: value)
        let nbrs = loc.neighbours().filter{ locationValues.keys.contains($0) }
        let locValue = max(1, locationValues.filter{ nbrs.contains($0.key) }.reduce(0, { $0 + $1.value }))
        if locValue > target { return locValue }
        locationValues.updateValue(locValue, forKey: loc)
        value += 1
    }
    return value
}

@main final class Today: Day {
    init() { super.init(day: 3, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var inputVal = 289_326
        let inputSquare = location(of: inputVal)
        print("Distance to square is \(abs(inputSquare.x) + abs(inputSquare.y))")
        print("First value larger than target is \(firstValueGreaterThan(target: inputVal))")
    }
    
    static func main() { Today().run() }
}
