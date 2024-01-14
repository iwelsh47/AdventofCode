//
//  Day16.swift
//  Day16_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation

enum DNASequencer {
    case children, cats, samoyeds, pomeranians, akitas, vixslas, goldfish, trees, cars, perfumes, none
    
    init(from description: String) {
        switch description {
            case "children": self = .children
            case "cats": self = .cats
            case "samoyeds": self = .samoyeds
            case "pomeranians": self = .pomeranians
            case "akitas": self = .akitas
            case "vizslas": self = .vixslas
            case "goldfish": self = .goldfish
            case "trees": self = .trees
            case "cars": self = .cars
            case "perfumes": self = .perfumes
            default: self = .none
        }
    }
}

struct Sue {
    let number: Int
    let sequences: [DNASequencer: Int]
    
    init(from description: String) {
        let bits = description.replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: ",", with: "")
            .components(separatedBy: " ")
        self.number = Int(bits[1])!
        var sequences = [DNASequencer: Int]()
        for index in stride(from: 2, to: bits.count, by: 2) {
            sequences[DNASequencer(from: bits[index])] = Int(bits[index + 1])
        }
        self.sequences = sequences
    }
    
    func matchesExact(output test: [DNASequencer: Int]) -> Bool {
        for (key, value) in test {
            guard let testValue = sequences[key] else { continue }
            if testValue != value { return false }
        }
        return true
    }
    
    func matchesRange(output test: [DNASequencer: Int]) -> Bool {
        for (key, value) in test {
            guard let testValue = sequences[key] else { continue }
            if (key == .cats || key == .trees) { if testValue <= value { return false } }
            else if (key == .pomeranians || key == .goldfish) { if testValue >= value { return false } }
            else if testValue != value { return false }
        }
        return true
    }
}

@main final class Today: Day {
    init() { super.init(day: 16, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let sues = data.components(separatedBy: "\n").map({ Sue(from: $0) })
        let output: [DNASequencer: Int] = [.children: 3, .cats: 7, .samoyeds: 2, .pomeranians: 3, .akitas: 0,
                                           .vixslas: 0, .goldfish: 5, .trees: 3, .cars: 2, .perfumes: 1 ]
        let exactSue = sues.filter({ $0.matchesExact(output: output) })
        print("Sue that matches exactly is \(exactSue.first!.number)")
        let rangeSue = sues.filter({ $0.matchesRange(output: output) })
        print("Sue that matches rangely is \(rangeSue.first!.number)")
    }
    
    static func main() { Today().run() }
}
