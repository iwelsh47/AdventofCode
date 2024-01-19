//
//  Day05.swift
//  Day05_2016
//
//  Created by Ivan Welsh on 18/01/24.
//

import Foundation
import CryptoKit

func nextPasswordCharacter(of data: String,
                           countingFrom suffixInitial: Int,
                           leadingZeros: Int) -> (String, Int) {
    var trailingValue = suffixInitial
    var hash = Insecure.MD5.hash(data: "\(data)\(trailingValue)".data(using: .utf8)!).map({$0})
    while hash[0] != 0 || hash[1] != 0 || hash[2] > 15 {
        trailingValue += 1
        hash = Insecure.MD5.hash(data: "\(data)\(trailingValue)"
                                        .data(using: .utf8)!).map({$0})
    }
    return (String(hash[2], radix: 16), trailingValue + 1)
}

func passwordDecrypter(using data: String) -> String {
    var password = Array(repeating: "", count: 8)
    
    var trailingValue = 0
    while password.filter({ $0 != ""}).count != 8 {
        trailingValue += 1
        var hash = Insecure.MD5.hash(data: "\(data)\(trailingValue)".data(using: .utf8)!).map({$0})
        while hash[0] != 0 || hash[1] != 0 || hash[2] > 7 {
            trailingValue += 1
            hash = Insecure.MD5.hash(data: "\(data)\(trailingValue)"
                .data(using: .utf8)!).map({$0})
        }
        if password[Int(hash[2])] != "" { continue }
        let src = String(hash[3], radix:16)
        if src.count == 1 { password[Int(hash[2])] = "0" }
        else { password[Int(hash[2])] = String(src.first!) }
    }
    
    
    
    return password.joined(separator: "")
}

@main final class Today: Day {
    init() { super.init(day: 5, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let leadChars = "reyedfim"
        var startTrailing = 0
        var password: [String] = []
        for _ in 1...8 {
            let char: String
            (char, startTrailing) = nextPasswordCharacter(of: leadChars, countingFrom: startTrailing, leadingZeros: 5)
            password.append(char)
        }
        print("The 8 character password is: ", password.joined(separator: ""))
        print("The decrypted password is: \(passwordDecrypter(using: leadChars))")
    }
    
    static func main() { Today().run() }
}
