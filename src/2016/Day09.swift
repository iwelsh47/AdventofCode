//
//  Day09.swift
//  Day09_2016
//
//  Created by Ivan Welsh on 20/01/24.
//

import Foundation

@main final class Today: Day {
    init() { super.init(day: 9, year: 2016) }
    
    func decompress(string: String) -> String {
        var decompressed = [String]()
        var index = string.startIndex
        while index < string.endIndex {
            guard let firstOpen = string[index...].firstIndex(of: "(") else { break }
            guard let firstClose = string[index...].firstIndex(of: ")") else { break }
            // Append everything leading up to the first open
            decompressed.append(String(string[index..<firstOpen]))
            let (n, times) = string[string.index(after: firstOpen)..<firstClose]
                                .components(separatedBy: "x")
                                .map({ Int($0)! })
                                .splat()
            let startIdx = string[index...].index(after: firstClose)
            let endIdx = string[index...].index(startIdx, offsetBy: n)
            let toAppend = String(repeating: String(string[index...][startIdx..<endIdx]), count: times)
            decompressed.append(toAppend)
            index = endIdx
        }
        decompressed.append(String(string[index...]))
        
        return decompressed.joined(separator: "")
    }
    
    func determinedDecompressedLength(of string: String) -> Int {
        var length = 0
        var index = string.startIndex
        while index < string.endIndex {
            guard let firstOpen = string[index...].firstIndex(of: "(") else { break }
            guard let firstClose = string[index...].firstIndex(of: ")") else { break }
            length += string[index..<firstOpen].count
            let (n, times) = string[string.index(after: firstOpen)..<firstClose]
                                .components(separatedBy: "x")
                                .map({ Int($0)! })
                                .splat()
            let startIdx = string[index...].index(after: firstClose)
            let endIdx = string[index...].index(startIdx, offsetBy: n)
            length += times * determinedDecompressedLength(of: String(string[index...][startIdx..<endIdx]))
            index = endIdx
        }
        length += string[index...].count
        return length
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        print("Decompressed file length is \(decompress(string: data).count).")
        print("V2 decompressed length is \(determinedDecompressedLength(of: data))")
    }
    
    static func main() { Today().run() }
}
