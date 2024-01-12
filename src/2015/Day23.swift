//
//  Day23.swift
//  Day22_2015
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation

enum Register { case a, b, none }

protocol Instruction {
    var offset: Int { get }
    var register: Register { get }
    
    func execute(on computer: inout Computer)
}

struct NoOp: Instruction {
    let offset: Int = 0
    let register: Register = .none
    func execute(on computer: inout Computer) { }
}

struct Half: Instruction {
    let offset: Int = 1
    let register: Register
    init(register: Register) {
        self.register = register
    }
    func execute(on computer: inout Computer) {
        if register == .a { computer.registerA /= 2 }
        else { computer.registerB /= 2 }
        computer.instructionIndex += offset
    }
}

struct Triple: Instruction {
    let offset: Int = 1
    let register: Register
    init(register: Register) {
        self.register = register
    }
    func execute(on computer: inout Computer) {
        if register == .a { computer.registerA *= 3 }
        else { computer.registerB *= 3 }
        computer.instructionIndex += offset
    }
}

struct Increment: Instruction {
    let offset: Int = 1
    let register: Register
    init(register: Register) {
        self.register = register
    }
    func execute(on computer: inout Computer) {
        if register == .a { computer.registerA += 1 }
        else { computer.registerB += 1 }
        computer.instructionIndex += offset
    }
}

struct Jump: Instruction {
    let offset: Int
    let register: Register = .none
    init(offset: Int) {
        self.offset = offset
    }
    func execute(on computer: inout Computer) {
        computer.instructionIndex += offset
    }
}

struct JumpIfEven: Instruction {
    let offset: Int
    let register: Register
    func execute(on computer: inout Computer) {
        let registerValue = register == .a ? computer.registerA : computer.registerB
        if registerValue.isMultiple(of: 2) { computer.instructionIndex += offset }
        else { computer.instructionIndex += 1 }
    }
}

struct JumpIfOne: Instruction {
    let offset: Int
    let register: Register
    func execute(on computer: inout Computer) {
        let registerValue = register == .a ? computer.registerA : computer.registerB
        if registerValue == 1 { computer.instructionIndex += offset }
        else { computer.instructionIndex += 1 }
    }
}

func buildInstruction(from info: String) -> Instruction {
    let bits = info.components(separatedBy: " ")
    switch bits[0] {
        case "hlf": return Half(register: (bits[1] == "a" ? .a : .b))
        case "tpl": return Triple(register: (bits[1] == "a" ? .a : .b))
        case "inc": return Increment(register: (bits[1] == "a" ? .a : .b))
        case "jmp": return Jump(offset: Int(bits[1])!)
        case "jie": return JumpIfEven(offset: Int(bits[2])!, register: (bits[1] == "a" ? .a : .b))
        case "jio": return JumpIfOne(offset: Int(bits[2])!, register: (bits[1] == "a" ? .a : .b))
        default: return NoOp()
    }
}

struct Computer {
    var registerA = 0
    var registerB = 0
    let program: [Instruction]
    var instructionIndex = 0
    init(program: String) {
        self.program = program.components(separatedBy: "\n").map({ buildInstruction(from: $0) })
    }
    
    mutating func runProgram() {
        while instructionIndex < program.count {
            program[instructionIndex].execute(on: &self)
        }
    }
    
    mutating func reset(initialA: Int = 0, initialB: Int = 0) {
        registerA = initialA
        registerB = initialB
        instructionIndex = 0
    }
}

@main final class Today: Day {
    init() { super.init(day: 23, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var computer = Computer(program: data)
        computer.runProgram()
        print("After execution, register b is \(computer.registerB)")
        computer.reset(initialA: 1)
        computer.runProgram()
        print("Starting at A = 1, register b is \(computer.registerB)")
    }
    
    static func main() { Today().run() }
}
