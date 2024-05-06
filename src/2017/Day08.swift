//
//  Day08.swift
//  Day08_2017
//
//  Created by Ivan Welsh on 6/02/24.
//

import Foundation

enum Instruction {
    case inc, dec
    
    static func convert(from str: String) -> Instruction {
        if str == "inc" { return .inc }
        return .dec
    }
}

enum Compare {
    case gt, lt, eq, gte, lte, neq
    
    static func convert(from str: String) -> Compare {
        if str == ">" { return .gt }
        if str == "<" { return .lt }
        if str == "==" { return .eq }
        if str == ">=" { return .gte }
        if str == "<=" { return .lte }
        return .neq
    }
    
    func perform(a: Int, b: Int) -> Bool {
        switch self {
            case .eq: return a == b
            case .gt: return a > b
            case .gte: return a >= b
            case .lt: return a < b
            case .lte: return a <= b
            case .neq: return a != b
        }
    }
}

@main final class Today: Day {
    init() { super.init(day: 8, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var registers = [String: Int]()
        var highestEver = 0
        for instruction in data.components(separatedBy: .newlines) {
            let bits = instruction.components(separatedBy: .whitespaces)
            let register = bits[0]
            let shift = Instruction.convert(from: bits[1])
            let amount = Int(bits[2])!
            let checkRegister = bits[4]
            let checkOp = Compare.convert(from: bits[5])
            let checkValue = Int(bits[6])!
            if !checkOp.perform(a: registers[checkRegister, default: 0], b: checkValue) { continue }
            switch shift {
                case .dec: registers[register, default: 0] -= amount
                case .inc: registers[register, default: 0] += amount
            }
            if registers[register]! > highestEver { highestEver = registers[register]! }
        }
        print("Maximum register value is \(registers.values.max()!)")
        print("Highest value ever held is \(highestEver)")
    }
    
    static func main() { Today().run() }
}
