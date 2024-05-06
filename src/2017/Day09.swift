//
//  Day09.swift
//  Day09_2017
//
//  Created by Ivan Welsh on 6/02/24.
//

import Foundation

func removeGarbage(from str: String) -> (clean: String, removed: Int) {
    var cleanString = str
    var startIdx = cleanString.firstIndex(of: "<")
    var totalRemoved = 0
    while startIdx != nil {
        var endIdx = cleanString.index(after: startIdx!)
        var  removeAmount = 0
        while cleanString[endIdx] != ">" {
            if cleanString[endIdx] == "!" { endIdx = cleanString.index(endIdx, offsetBy: 2) }
            else {
                endIdx = cleanString.index(after: endIdx)
                removeAmount += 1
            }
        }
        cleanString.replaceSubrange(startIdx!...endIdx, with: "")
        totalRemoved += removeAmount
        startIdx = cleanString.firstIndex(of: "<")
    }
    return (cleanString, totalRemoved)
}

func scoreGroups(from str: String) -> Int {
    var score = 0
    var level = 0
    for char in str {
        if char == "{" { level += 1 }
        if char == "}" {
            score += level
            level -= 1
        }
    }
    return score
}

@main final class Today: Day {
    init() { super.init(day: 9, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let (cleanData, removed) = removeGarbage(from: data)
        print("Score of input string is \(scoreGroups(from: cleanData))")
        print("Amount removed is \(removed)")
    }
    
    static func main() { Today().run() }
}

