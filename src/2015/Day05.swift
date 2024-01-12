//
//  Day05.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation
@main final class Today: Day {
    init() { super.init(day: 5, year: 2015)}
    
    /*
     Santa needs help figuring out which strings in his text file are naughty or nice.
     
     A nice string is one with all of the following properties:
     
     It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
     It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
     It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
     
     For example:
     
     ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of
     the disallowed substrings.
     aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules
     overlap.
     jchzalrnumimnmhp is naughty because it has no double letter.
     haegwjzuvuyypxyu is naughty because it contains the string xy.
     dvszwmarrgswjxmb is naughty because it contains only one vowel.
     
     How many strings are nice?
     */
    
    func isNice(string: String) -> Bool {
        // Vowel count
        let vowelCount = string.filter({"aeiou".contains($0)}).count
        let doubleLetterCount = string[..<(string.index(string.endIndex, offsetBy: -1))]
            .enumerated()
            .filter({(n, char) in char == string[string.index(string.startIndex, offsetBy: n + 1)]}).count
        
        if vowelCount < 3 { return false }
        // Double letter
        if doubleLetterCount < 1 { return false }
        // Bad substrings
        for substring in ["ab", "cd", "pq", "xy"] {
            if string.contains(substring) { return false }
        }
        return true
    }
    
    /*
     Realizing the error of his ways, Santa has switched to a better model of determining whether a string is naughty or
     nice. None of the old rules apply, as they are all clearly ridiculous.
     
     Now, a nice string is one with all of the following properties:
     
     It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) 
     or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
     It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or 
     even aaa.
     
     For example:
     
     qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one 
     letter between them (zxz).
     xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the 
     letters used by each rule overlap.
     uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
     ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears 
     twice.
     
     How many strings are nice under these new rules?
     */
    func isNewlyNice(string: String) -> Bool {
        // Repeated pairs
        var repeatedPairCount = 0
        for offset in 0..<string.count - 1 {
            let startIndex = string.index(string.startIndex, offsetBy: offset)
            let letterPair = string[startIndex...string.index(startIndex, offsetBy: 1)]
            if (string[string.index(startIndex, offsetBy: 2)...].contains(letterPair)) { repeatedPairCount += 1 }
        }
        
        // Repeat with letter between
        var oneBetweenCount = 0
        for offset in 0..<string.count - 2 {
            let startIndex = string.index(string.startIndex, offsetBy: offset)
            let letterTriple = string[startIndex...string.index(startIndex, offsetBy: 2)]
            if (letterTriple.first == letterTriple.last) { oneBetweenCount += 1 }
        }
        
        return repeatedPairCount > 0 && oneBetweenCount > 0
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let niceStrings = data.components(separatedBy: "\n").filter({ isNice(string: $0)}).count
        print("There are \(niceStrings) nice strings")
        let newNiceStrings = data.components(separatedBy: "\n").filter({ isNewlyNice(string: $0)}).count
        print("There are \(newNiceStrings) newly nice strings")
    }
    
    static func main() { Today().run() }
}

