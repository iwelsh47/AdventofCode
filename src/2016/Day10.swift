//
//  Day10.swift
//  Day10_2016
//
//  Created by Ivan Welsh on 20/01/24.
//

import Foundation

struct Bot {
    let number: Int
    var values: [Int]
    
    init(number: Int) {
        self.values = [Int]()
        self.number = number
    }
    
    func canGive() -> Bool {
        return values.count == 2
    }
    
    var low: Int? {
        get {
            if values.count != 2 { return nil}
            return values.min()
        }
    }
    
    var high: Int? {
        get {
            if values.count != 2 { return nil}
            return values.max()
        }
    }
}

struct Instruction {
    let bot: Int
    let high: Int
    let low: Int
    let lowOutput: Bool
    let highOutput: Bool
    var done = false
}

@main final class Today: Day {
    init() { super.init(day: 10, year: 2016) }
    
    override func run() {
        var instructions = [Instruction]()
        var bots = [Int: Bot]()
        var outputs = [Int: [Int]]()
        print("Running \(year), day \(day)")
        for instruction in data.components(separatedBy: "\n") {
            let bits = instruction.components(separatedBy: " ")
            if bits[0] == "value" {
                let number = Int(bits[5])!
                bots[number, default: Bot(number: number)].values.append(Int(bits[1])!)
            } else {
                let bot = Int(bits[1])!
                let low = Int(bits[6])!
                let high = Int(bits[11])!
                instructions.append(Instruction(bot: bot, high: high, low: low,
                                                lowOutput: bits[5] == "output",
                                                highOutput: bits[10] == "output"))
            }
        }
        while instructions.filter({ !$0.done }).isNotEmpty {
            for i in 0..<instructions.count {
                if instructions[i].done { continue }
                guard let bot = bots[instructions[i].bot] else { continue }
                if bot.canGive() {
                    if instructions[i].lowOutput { outputs[instructions[i].low, default: [Int]()].append(bot.low!) }
                    else { bots[instructions[i].low, default: Bot(number: instructions[i].low)].values.append(bot.low!) }
                    if instructions[i].highOutput { outputs[instructions[i].high, default: [Int]()].append(bot.high!) }
                    else { bots[instructions[i].high, default: Bot(number: instructions[i].high)].values.append(bot.high!) }
                    instructions[i].done = true
                }
            }
        }
        let firstComp = bots.values.filter({ $0.high == 61 && $0.low == 17 }).first!
        print("To compare 61 with 17, bot \(firstComp.number)")
        let multi = outputs[0]!.first! * outputs[1]!.first! * outputs[2]!.first!
        print("Multiplying outputs 0 to 2 together gets \(multi)")
    }
    
    static func main() { Today().run() }
}
