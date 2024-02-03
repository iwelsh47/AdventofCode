//
//  Day07.swift
//  Day07_2016
//
//  Created by Ivan Welsh on 20/01/24.
//

import Foundation

func isABBA(testString: Substring) -> Bool {
    let i0 = testString.startIndex
    let i1 = testString.index(after: i0)
    let i2 = testString.index(after: i1)
    let i3 = testString.index(after: i2)
    return testString[i0] == testString[i3] && testString[i1] == testString[i2] && testString[i0] != testString[i1]
}

func isABA_or_BAB(testString: Substring) -> Bool {
    let i0 = testString.startIndex
    let i1 = testString.index(after: i0)
    let i2 = testString.index(after: i1)
    return testString[i0] == testString[i2] && testString[i0] != testString[i1]
}

func correspond(aba: String, bab: String) -> Bool {
    let i0 = aba.startIndex
    let i1 = aba.index(after: i0)
    let j0 = bab.startIndex
    let j1 = bab.index(after: j0)
    return aba[i0] == bab[j1] && aba[i1] == bab[j0]
}

func supportsTLS(ip: String) -> Bool {
    var inHypernet = 0
    var index = ip.startIndex
    var hasABBA = false
    while index < ip.index(ip.endIndex, offsetBy: -3) {
        let abbaCheck = ip[index..<ip.index(index, offsetBy: 4)]
        if abbaCheck.last! == "[" {
            inHypernet += 1
            index = ip.index(index, offsetBy: 4)
        } else if abbaCheck.last! == "]" {
            inHypernet -= 1
            index = ip.index(index, offsetBy: 4)
        } else {
            let test = isABBA(testString: abbaCheck)
            if test && inHypernet == 0 { hasABBA = true }
            else if test { return false }
            index = ip.index(after: index)
        }
    }
    return hasABBA
}

func supportsSSL(ip: String) -> Bool {
    var inHypernet = 0
    var foundABA = [String]()
    var foundBAB = [String]()
    var index = ip.startIndex
    while index < ip.index(ip.endIndex, offsetBy: -2) {
        let check = ip[index..<ip.index(index, offsetBy: 3)]
        if check.last == "[" {
            inHypernet += 1
            index = ip.index(index, offsetBy: 3)
        } else if check.last == "]" {
            inHypernet -= 1
            index = ip.index(index, offsetBy: 3)
        } else {
            let test = isABA_or_BAB(testString: check)
            if test && inHypernet == 0 { foundABA.append(String(check)) }
            else if test { foundBAB.append(String(check)) }
            index = ip.index(after: index)
        }
    }
    
    for aba in foundABA {
        for bab in foundBAB {
            if correspond(aba: aba, bab: bab) { return true }
        }
    }
    return false
}

@main final class Today: Day {
    init() { super.init(day: 7, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let numTLS = data.components(separatedBy: "\n").filter({ supportsTLS(ip: $0) }).count
        print("Number of TSL supported IPs is \(numTLS)")
        let numSSL = data.components(separatedBy: "\n").filter({ supportsSSL(ip: $0) }).count
        print("Number of SSL supported IPs is \(numSSL)")
    }
    
    static func main() { Today().run() }
}
