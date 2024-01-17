//
//  Day19.swift
//  Day19_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation

struct SubstringSwap : Comparable {
    static func < (lhs: SubstringSwap, rhs: SubstringSwap) -> Bool {
        return rhs.to.count < lhs.to.count
    }
    
    let from: String
    let to: String
    
    init(from pairing: String) { (self.from, self.to) = pairing.components(separatedBy: " => ").splat() }
}

extension String {
    func replacingOccurances(of target: String,
                             with replacement: String) -> [String] {
        var replacedInstances = [String]()
        var searchRange = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
        while let foundRange = range(of: target, options: [], range: searchRange) {
            let replaceRange = Range(uncheckedBounds: (lower: searchRange.lowerBound, upper: foundRange.upperBound))
            replacedInstances.append(replacingOccurrences(of: target, with: replacement, options: [], range: replaceRange))
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        
        return replacedInstances
    }
    
    func replacingOccurances(of target: String,
                             with replacement: String,
                             num: Int?) -> String? {
        guard let num else { return self.replacingOccurrences(of: target, with: replacement, options: []) }
        var foundCount = 0
        var searchRange = Range(uncheckedBounds: (startIndex, endIndex))
        while let foundRange = range(of: target, options: [], range: searchRange) {
            foundCount += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
            if foundCount == num { break }
        }
        if foundCount == 0 { return nil }
        return replacingOccurrences(of: target, with: replacement, options: [], range: Range(uncheckedBounds: (startIndex, searchRange.lowerBound)))
        
    }
}

@main final class Today: Day {
    init() { super.init(day: 19, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let swaps = data.components(separatedBy: "\n").map({ SubstringSwap(from: $0) }).sorted()
        let string = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"
        let uniqueStrings = swaps.reduce(into: Set<String>(), { $0.formUnion(string.replacingOccurances(of: $1.from, with: $1.to))})
        print("There are \(uniqueStrings.count) unique replacements")
        
        var replaceCount = 0
        var replacedString = string
        while replacedString != "e" {
            for substitute in swaps {
                var shouldBreak = false
                while let newString = replacedString.replacingOccurances(of: substitute.to, with: substitute.from, num: 1) {
                    replaceCount += 1
                    replacedString = newString
                    shouldBreak = true
                }
                if shouldBreak { break }
            }
        }
        print("It takes \(replaceCount) replaacements to get the string.")
    }
    
    static func main() { Today().run() }
}
