//
//  Day23.swift
//  Day23_2016
//
//  Created by Ivan Welsh on 3/02/24.
//

import Foundation


@main final class Today: Day {
    init() { super.init(day: 23, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        
        let instructions = InstructionSet(from: data)
        instructions.follow(memory: [.a: 7])
        print("Value to enter is \(instructions.memory[.a]!)")
        // TODO: Optimise dec/inc, jnz loops as multiplies
        instructions.reset(to: data)
        instructions.follow(memory: [.a: 12])
        print("Real value to enter is \(instructions.memory[.a]!)")
    }
    
    static func main() { Today().run() }
}
