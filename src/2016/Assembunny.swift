//
//  Assembunny.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 3/02/24.
//

import Foundation

enum OpCode {
    case cpy, inc, dec, jnz, tgl, out, none
    
    static func convert(from str: String) -> OpCode {
        switch str {
            case "cpy": return .cpy
            case "inc": return .inc
            case "dec": return .dec
            case "jnz": return .jnz
            case "tgl": return .tgl
            case "out": return .out
            default: return .none
        }
    }
}

enum Register {
    case a, b, c, d, none
    
    static func convert(from str: String) -> Register {
        switch str {
            case "a": return .a
            case "b": return .b
            case "c": return .c
            case "d": return .d
            default: return .none
        }
    }
}

struct Instruction {
    var type: OpCode
    let regX: Register
    let regY: Register
    let intX: Int?
    let intY: Int?
    
    init(from str: String) {
        let bits = str.components(separatedBy: " ")
        type = OpCode.convert(from: bits[0])
        regX = Register.convert(from: bits[1])
        intX = Int(bits[1])
        if bits.count == 3 {
            regY = Register.convert(from: bits[2])
            intY = Int(bits[2])
        } else {
            regY = .none
            intY = nil
        }
    }
}


class InstructionSet {
    public var memory = [Register: Int]()
    var instructions: [Instruction]
    var pointer = 0
    
    init(from str: String) {
        instructions = str.components(separatedBy: "\n").map{ Instruction(from: $0) }
    }
    
    func reset(to str: String) {
        instructions = str.components(separatedBy: "\n").map{ Instruction(from: $0) }
    }
    
    func tgl(x: Register, x2: Int?) {
        if x == .none { tgl(x: x2!) }
        else { tgl(x: x) }
    }
    func tgl(x: Register) { tgl(x: memory[x, default: 0]) }
    func tgl(x: Int) {
        let idx = pointer + x
        pointer += 1
        if idx < 0 || idx >= instructions.count { return }
        switch instructions[idx].type {
            case .inc: instructions[idx].type = .dec
            case .dec: instructions[idx].type = .inc
            case .tgl: instructions[idx].type = .inc
            case .out: instructions[idx].type = .inc
                
            case .cpy: instructions[idx].type = .jnz
            case .jnz: instructions[idx].type = .cpy
            case .none: return
        }
    }
    
    func inc(x: Register, x2: Int?) {
        if x == .none { inc(x: x2!) }
        else { inc(x: x) }
    }
    func inc(x: Register) { memory[x, default: 0] += 1; pointer += 1 }
    func inc(x: Int) { pointer += 1 }
    
    func dec(x: Register, x2: Int?) {
        if x == .none { dec(x: x2!) }
        else { dec(x: x) }
    }
    func dec(x: Register) { memory[x, default: 0] -= 1; pointer += 1 }
    func dec(x: Int) { pointer += 1}
    
    func out(x: Register, x2: Int?) -> Int {
        if x == .none { out(x: x2!) }
        else { out(x: x) }
    }
    func out(x: Register) -> Int { pointer += 1; return memory[x, default: 0] }
    func out(x: Int) -> Int { pointer += 1; return x }
    
    func jnz(x: Register, x2: Int?, y: Register, y2: Int?) {
        if x == .none && y == .none { jnz(x: x2!, y: y2!) }
        else if x == .none && y != .none { jnz(x: x2!, y: y) }
        else if x != .none && y != .none { jnz(x: x, y: y) }
        else if x != .none && y == .none { jnz(x: x, y: y2!) }
    }
    func jnz(x: Register, y: Register) { jnz(x: memory[x, default: 0], y: memory[y, default: 0]) }
    func jnz(x: Register, y: Int) { jnz(x: memory[x, default: 0], y: y) }
    func jnz(x: Int, y: Register) { jnz(x: x, y: memory[y, default: 0]) }
    func jnz(x: Int, y: Int) {
        if x != 0 { pointer += y }
        else { pointer += 1 }
    }
    
    
    func cpy(x: Register, x2: Int?, y: Register, y2: Int?) {
        if x == .none && y == .none { cpy(x: x2!, y: y2!) }
        else if x == .none && y != .none { cpy(x: x2!, y: y) }
        else if x != .none && y != .none { cpy(x: x, y: y) }
        else if x != .none && y == .none { cpy(x: x, y: y2!) }
    }
    func cpy(x: Register, y: Register) { memory[y, default: 0] = memory[x, default: 0]; pointer += 1 }
    func cpy(x: Int, y: Register) { memory[y, default: 0] = x; pointer += 1 }
    func cpy(x: Register, y: Int) { pointer += 1 }
    func cpy(x: Int, y: Int) { pointer += 1 }
    
    func follow(memory: [Register: Int] = [Register: Int](),
                until targetOut: [Int]? = nil) -> Bool? {
        self.memory = memory
        self.pointer = 0
        var output = [Int]()
        
        while pointer < instructions.count {
            let regX = instructions[pointer].regX
            let regY = instructions[pointer].regY
            let intX = instructions[pointer].intX
            let intY = instructions[pointer].intY
            
            switch instructions[pointer].type {
                case .inc: inc(x: regX, x2: intX)
                case .dec: dec(x: regX, x2: intX)
                case .tgl: tgl(x: regX, x2: intX)
                case .out: output.append(out(x: regX, x2: intX))
                case .cpy: cpy(x: regX, x2: intX, y: regY, y2: intY)
                case .jnz: jnz(x: regX, x2: intX, y: regY, y2: intY)
                default: break
            }
            
            if let target = targetOut {
                if output.count < target.count { continue }
                for idx in 0..<output.count {
                    if output[idx] != target[idx] { return false }
                }
                if output.count == target.count { return true }
            }
        }
        return nil
    }
}
