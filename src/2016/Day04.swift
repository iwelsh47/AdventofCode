//
//  Day04.swift
//  Day04_2016
//
//  Created by Ivan Welsh on 18/01/24.
//

import Foundation

struct Room {
    let name: String
    let sectorID: Int
    let checksum: String
    
    init(from info: String) {
        let bits = info.components(separatedBy: "-")
        let (sectorID, checksum) = bits.last!.replacing("]", with: "").components(separatedBy: "[").splat()
        self.name = bits[0..<(bits.count - 1)].joined(separator: "-")
        self.sectorID = Int(sectorID)!
        self.checksum = checksum
    }
    
    var isValid: Bool {
        get {
            struct NameCount: SortComparator {
                func compare(_ lhs: (key: Character, value: Int), _ rhs: (key: Character, value: Int)) -> ComparisonResult {
                    if lhs.value < rhs.value { return .orderedDescending }
                    if lhs.value > rhs.value { return .orderedAscending }
                    if lhs.key < rhs.key { return .orderedAscending }
                    return .orderedDescending
                }
                
                typealias Compared = (key: Character, value: Int)
                var order: SortOrder
            }
            
            var charCounts = [Character: Int]()
            for char in name {
                if char == "-" { continue }
                charCounts[char, default: 0] += 1
            }
            let sortedChars = charCounts.sorted(using: NameCount(order: .reverse))
            for (index, char) in checksum.enumerated() {
                if char != sortedChars[index].key { return false }
            }
            return true
        }
    }
    
    
    
    func decrypt() -> String {
        var newName = [Character]()
        for char in name {
            if char == "-" {
                newName.append(" ")
                continue
            }
            let asciiValue = Int(char.asciiValue!)
            let newAsciiValue = UInt8((((asciiValue - 97) + sectorID) % 26) + 97)
            newName.append(Character(UnicodeScalar(newAsciiValue)))
        }
        return String(newName.map({ String($0) }).joined(separator: ""))
    }
    
}

@main final class Today: Day {
    init() { super.init(day: 4, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let rooms = data.split(separator: "\n").map({ Room(from: String($0)) })
        let validRooms = rooms.filter({ $0.isValid })
        let sectorIDSum = validRooms.map({ $0.sectorID }).sum()
        print("Sum of valid sector IDs is \(sectorIDSum)")
        for room in validRooms {
            let decrypted = room.decrypt()
            if decrypted.starts(with: "north") {
                print(decrypted, room.sectorID)
            }
        }
    }
    
    static func main() { Today().run() }
}
