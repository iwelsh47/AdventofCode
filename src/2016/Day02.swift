//
//  Day02.swift
//  Day25_2015
//
//  Created by Ivan Welsh on 17/01/24.
//

import Foundation

struct NumberPad {
    let buttons: [Int: Button]
    
    func followDirections(starting: Int, directions: String) -> Int {
        var location = starting
        for char in directions {
            switch char {
                case "U": location = buttons[location]?.up ?? location
                case "D": location = buttons[location]?.down ?? location
                case "L": location = buttons[location]?.left ?? location
                case "R": location = buttons[location]?.right ?? location
                default: continue
            }
        }
        return location
    }
}

struct Button {
    let up: Int?
    let down: Int?
    let left: Int?
    let right: Int?
}

func buildNormalNumberPad() -> NumberPad {
    return NumberPad(buttons: [1: Button(up: nil, down: 4, left: nil, right: 2),
                               2: Button(up: nil, down: 5, left: 1, right: 3),
                               3: Button(up: nil, down: 6, left: 2, right: nil),
                               4: Button(up: 1, down: 7, left: nil, right: 5),
                               5: Button(up: 2, down: 8, left: 4, right: 6),
                               6: Button(up: 3, down: 9, left: 5, right: nil),
                               7: Button(up: 4, down: nil, left: nil, right: 8),
                               8: Button(up: 5, down: nil, left: 7, right: 9),
                               9: Button(up: 6, down: nil, left: 8, right: nil)])
}

func buildStrangeNumberPad() -> NumberPad {
    return NumberPad(buttons: [1: Button(up: nil, down: 3, left: nil, right: nil),
                               2: Button(up: nil, down: 6, left: nil, right: 3),
                               3: Button(up: 1, down: 7, left: 2, right: 4),
                               4: Button(up: nil, down: 8, left: 3, right: nil),
                               5: Button(up: nil, down: nil, left: nil, right: 6),
                               6: Button(up: 2, down: 10, left: 5, right: 7),
                               7: Button(up: 3, down: 11, left: 6, right: 8),
                               8: Button(up: 4, down: 12, left: 7, right: 9),
                               9: Button(up: nil, down: nil, left: 8, right: nil),
                               10: Button(up: 6, down: nil, left: nil, right: 11),
                               11: Button(up: 7, down: 13, left: 10, right: 12),
                               12: Button(up: 8, down: nil, left: 11, right: nil),
                               13: Button(up: 11, down: nil, left: nil, right: nil)])
}

public extension String.StringInterpolation {
    /// Represents a single numeric radix
    enum Radix: Int {
        case binary = 2, octal = 8, decimal = 10, hex = 16
        
        /// Returns a radix's optional prefix
        var prefix: String {
            return [.binary: "0b", .octal: "0o", .hex: "0x"][self, default: ""]
        }
    }
    
    mutating func appendInterpolation<I: Collection>(_ value: I, radix: Radix) where I.Element: BinaryInteger {
        // Values are uppercased hex
        var string = value.map({ String($0, radix: radix.rawValue).uppercased() })
        appendInterpolation(string)
    }
}

@main final class Today: Day {
    init() { super.init(day: 2, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let numberPad = buildNormalNumberPad()
        let strangeNumberPad = buildStrangeNumberPad()
        var numbers: [Int] = []
        var strangeNums: [Int] = []
        for line in data.components(separatedBy: "\n") {
            numbers.append(numberPad.followDirections(starting: numbers.last ?? 5, directions: line))
            strangeNums.append(strangeNumberPad.followDirections(starting: strangeNums.last ?? 5, directions: line))
        }
        print("Normal number pad code is \(numbers)")
        print("Strange number pad code is \(strangeNums, radix: .hex)")
        
    }
    
    static func main() { Today().run() }
}
