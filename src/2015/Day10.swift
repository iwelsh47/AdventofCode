//
//  Day10.swift
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation

@main final class Today: Day {
    init() { super.init(day: 10, year: 2015) }
    
    func lookAndSay(number input: String) -> String {
        var numberRuns = [String]()
        var previousChar = input.first!
        var previousCount = 1
        var index = input.index(after: input.startIndex)
        while index != input.endIndex {
            let char = input[index]
            if char == previousChar { previousCount += 1}
            else {
                numberRuns.append("\(previousCount)\(previousChar)")
                previousChar = char
                previousCount = 1
            }
            index = input.index(after: index)
        }
        numberRuns.append("\(previousCount)\(previousChar)")
        return numberRuns.joined(separator: "")
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        var input = "1321131112"
        for _ in 0..<40 {
            input = lookAndSay(number: input)
        }
        print("After 40 iterations the string length is \(input.count)")
        for _ in 0..<10 {
            input = lookAndSay(number: input)
        }
        print("After 50 iterations the string length is \(input.count)")
    }
    
    static func main() { Today().run() }
}
