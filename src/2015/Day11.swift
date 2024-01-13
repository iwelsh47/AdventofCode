//
//  Day11.swift
//  Day11_2015
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation

@main final class Today: Day {
    init() {
        let allLetters = "abcdefghijklmnopqrstuvwxyz"
        let nextLetter = "bcdefghijklmnopqrstuvwxyza"
        let thirdLetter = "cdefghijklmnopqrstuvwxyz"
        
        self.allLetters = allLetters.reduce(into: [Character : Character](), {
            let idx = allLetters.firstIndex(of: $1)!
            $0[$1] = nextLetter[idx]
        })
        
        doubleLetters = Set(allLetters.map({ "\($0)\($0)" }))
        threeRuns = Set(thirdLetter.map({
            let idx = thirdLetter.firstIndex(of: $0)!
            return "\(allLetters[idx])\(nextLetter[idx])\($0)"
        }))
        super.init(day: 11, year: 2015)
        
    }
    
    let allLetters: [Character : Character]
    
    let doubleLetters: Set<String>
    let threeRuns: Set<String>
    
    func increment(password: String) -> String {
        var newPassword = Array(password)
        for (index, initialChar) in newPassword.enumerated().reversed() {
            newPassword[newPassword.index(newPassword.startIndex, offsetBy: index)] = allLetters[initialChar]!
            if initialChar != "z" { break }
        }
        return String(newPassword)
    }
    
    func isValid(password: String) -> Bool {
        let threeLetterSequence = {
            var index = password.startIndex
            while index != password.index(password.endIndex, offsetBy: -2) {
                let substring = String(password[index...password.index(index, offsetBy: 2)])
                if self.threeRuns.contains(substring) { return true }
                index = password.index(after: index)
            }
            return false
        }
        
        let noIOL = {
            !password.contains("i") && !password.contains("o") && !password.contains("l")
        }
        
        let nonOverlappingPairs = {
            var pairCount = 0
            var index = password.startIndex
            while index < password.index(before: password.endIndex) {
                let substring = password[index...password.index(after: index)]
                if substring.first! == substring.last! {
                    pairCount += 1
                    index = password.index(after: index) // to let step by 2
                }
                index = password.index(after: index)
            }
            return pairCount >= 2
        }
        
        return noIOL() && threeLetterSequence() && nonOverlappingPairs()
    }
    
    func nextValidPassword(from password: String) -> String {
        var nextPassword = increment(password: password)
        while !isValid(password: nextPassword) { nextPassword = increment(password: nextPassword) }
        return nextPassword
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let nextPassword = nextValidPassword(from: "vzbxkghb")
        print("Santa's next valid password is \(nextPassword)")
        print("and the one after than is \(nextValidPassword(from: nextPassword))")
    }
    
    static func main() { Today().run() }
}
