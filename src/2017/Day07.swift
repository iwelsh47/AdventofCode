//
//  Day07.swift
//  Day07_2017
//
//  Created by Ivan Welsh on 6/02/24.
//

import Foundation

class Program: Hashable {
    static func == (lhs: Program, rhs: Program) -> Bool { lhs.name == rhs.name }
    
    func hash(into hasher: inout Hasher) { name.hash(into: &hasher) }
    
    let value: Int
    let name: String
    var supports: [Program]
    var supportedBy: Program?
    
    init(value: Int, name: String) {
        self.value = value
        self.name = name
        self.supports = []
        self.supportedBy = nil
    }
    
    var weight: Int {
        get {
            var w = value
            for support in supports {
                w += support.weight
            }
            return w
        }
    }
}

func createProgram(from str: String, existingPrograms: inout [Program]) {
    let bits = str.components(separatedBy: .whitespaces)
    let name = bits[0]
    let value = Int(bits[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))!
    existingPrograms.append(Program(value: value, name: name))
}

struct ProgramTree {
    let programs: [Program]
    init(from str: String) {
        var programs = [Program]()
        for p in str.components(separatedBy: .newlines) {
            createProgram(from: p, existingPrograms: &programs)
        }
        // Reiterate to add all the supports/supporting
        for p in str.components(separatedBy: .newlines) {
            let bits = p.components(separatedBy: .whitespaces)
            if bits.count == 2 { continue }
            let program = programs.first(where: { $0.name == bits[0] })!
            for support in bits[3...] {
                let sProgram = programs.first(where: { $0.name == support.replacingOccurrences(of: ",", with: "") })!
                program.supports.append(sProgram)
                sProgram.supportedBy = program
            }
        }
        self.programs = programs
    }
    
    var root: Program {
        get {
            return programs.first(where: { $0.supportedBy == nil })!
        }
    }
}

func badWeighted(from programs: [Program]) -> Program? {
    var weights = programs.reduce(into: [Program: Int](), { $0.updateValue($1.weight, forKey: $1) })
    var weightCounts = weights.values.reduce(into: [Int: Int](), { $0[$1, default: 0] += 1 })
    let badWeight = weightCounts.first(where: { $0.value == 1 })?.key
//    if badWeight == nil { return nil }
    return weights.first(where: { $0.value == badWeight })?.key
}

func fixedWeight(of pt: ProgramTree) -> (program: Program, weight: Int, fixed: Int) {
    var program = pt.root
    var badProgram = badWeighted(from: program.supports)
    while badProgram != nil {
        program = badProgram!
        badProgram = badWeighted(from: program.supports)
    }
    
    let changingProgram = program.supportedBy!
    let weights = changingProgram.supports.map { $0.weight }
    let weightCounts = weights.reduce(into: [Int: Int](), { $0[$1, default: 0] += 1 })
    let badWeight = weightCounts.first(where: { $0.value == 1 })!.key
    let goodWeight = weightCounts.first(where: { $0.value != 1 })!.key
    let weightChange = goodWeight - badWeight
    return (program, program.value, program.value + weightChange)
}

@main final class Today: Day {
    init() { super.init(day: 7, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let testData = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""
        let pt = ProgramTree(from: data)
        print("Bottom program is \(pt.root.name)")
        print("To fix the bad program weight needs to be \(fixedWeight(of: pt).fixed)")
    }
    
    static func main() { Today().run() }
}
