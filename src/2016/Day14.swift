//
//  Day14.swift
//  Day14_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation
import CryptoKit

func firstRunOf(length: Int, in str: String) -> Character? {
    var indicies = [str.startIndex]
    for i in 0..<(length - 1) { indicies.append(str.index(after: indicies[i])) }
    while indicies.last! != str.endIndex {
        var isRun = true
        for i in 1..<indicies.count {
            if str[indicies[i - 1]] != str[indicies[i]] {
                isRun = false
                break
            }
        }
        if isRun { return str[indicies.first!] }
        for i in 0..<indicies.count {
            indicies[i] = str.index(after: indicies[i])
        }
    }
    return nil
}

func hasRunOf(length: Int, char: Character, in str: String) -> Bool {
    guard let startIndex = str.firstIndex(of: char) else { return false }
    if str.countInstances(of: String(char)) < length { return false }
    var indicies = [startIndex]
    for i in 0..<(length - 1) { indicies.append(str.index(after: indicies[i])) }
    while indicies.last! < str.endIndex {
        var isRun = str[indicies.first!] == char
        for i in 1..<indicies.count {
            if str[indicies[i - 1]] != str[indicies[i]] {
                isRun = false
                break
            }
        }
        if isRun { return true }
        for i in 0..<indicies.count {
            indicies[i] = str.index(after: indicies[i])
        }
    }
    return false
}

extension String {
    func stretchedMD5(repeats: Int) -> String {
        var tmp = md5()
        for _ in 0..<repeats { tmp = tmp.md5() }
        return tmp
    }
}

struct MD5HashTable {
    var hashTable: [Int: String] = [:]
    let baseString: String
    var currentIndex: Int = -1
    
    init(base: String) {
        baseString = base
    }
    
    mutating func isKey(at index: Int, repeats: Int) -> Bool {
        let hash = hashTable[index]
        if hash == nil { hashTable[index] = "\(baseString)\(index)".stretchedMD5(repeats: repeats) }
        guard let char = firstRunOf(length: 3, in: hashTable[index]!)
        else { return false }
        
        for i in (index + 1)...(index + 1000) {
            let hash = hashTable[i]
            if hash == nil { hashTable[i] = "\(baseString)\(i)".stretchedMD5(repeats: repeats) }
            if hasRunOf(length: 5, char: char, in: hashTable[i]!) {
                return true
            }
        }
        return false
    }
    
    mutating func nextKey(stretched repeats: Int) -> (index: Int, hash: String) {
        currentIndex += 1
        while !isKey(at: currentIndex, repeats: repeats) {
            currentIndex += 1
        }
        return (currentIndex, hashTable[currentIndex]! )
    }
    
    mutating func reset() {
        hashTable.removeAll(keepingCapacity: true)
        currentIndex = -1
    }
}

@main final class Today: Day {
    init() { super.init(day: 14, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var table = MD5HashTable(base: "jlmsuwbz")
        var tableHashes = [(index: Int, hash: String)]()
        while tableHashes.count != 64 { tableHashes.append(table.nextKey(stretched: 0)) }
        print("64th key is \(tableHashes.last!)")
        
        table.reset()
        tableHashes.removeAll(keepingCapacity: true)
        while tableHashes.count != 64 { tableHashes.append(table.nextKey(stretched: 2016)) }
        print("64th key with stretched hashing is \(tableHashes.last!)")
    }
    
    static func main() { Today().run() }
}
