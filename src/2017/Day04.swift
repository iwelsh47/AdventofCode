//
//  Day04.swift
//  Day04_2017
//
//  Created by Ivan Welsh on 4/02/24.
//

import Foundation

func isValid(passphrase: String) -> Bool {
    let phraseList = passphrase.components(separatedBy: .whitespaces)
    let phraseSet = Set(phraseList)
    return phraseSet.count == phraseList.count
}

func isAnagramValid(passphrase: String) -> Bool {
    let phraseList = passphrase.components(separatedBy: .whitespaces)
    for i in 0..<phraseList.count {
        for j in i..<phraseList.count {
            if i == j { continue }
            if isAnagram(a: phraseList[i], b: phraseList[j]) { return false }
        }
    }
    return true
}

func isAnagram(a: String, b: String) -> Bool {
    var letterCounts = [Character: Int]()
    for char in a { letterCounts[char, default: 0] += 1 }
    for char in b {
        if (!letterCounts.keys.contains(char)) { return false }
        letterCounts[char, default: 0] -= 1
    }
    return letterCounts.filter{ $0.value != 0 }.count == 0
}

@main final class Today: Day {
    init() { super.init(day: 4, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let passphrases = data.components(separatedBy: .newlines)
        print("Number of valid is \(passphrases.filter{ isValid(passphrase: $0) }.count)")
        print("Number of anagram valid is \(passphrases.filter{ isAnagramValid(passphrase: $0) }.count)")
        print(isAnagram(a: "abcde", b: "ecdab"))
    }
    
    static func main() { Today().run() }
}
