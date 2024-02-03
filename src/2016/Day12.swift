//
//  Day12.swift
//  Day12_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation


@main final class Today: Day {
    init() { super.init(day: 12, year: 2016) }
    
    
    override func run() {
        print("Running \(year), day \(day)")
        
        let instructions = InstructionSet(from: data)
        instructions.follow()
        print("Initial instructions leave a at \(instructions.memory[.a]!)")
        instructions.follow(memory: [.c: 1])
        print("Follow up instructions leave a at \(instructions.memory[.a]!)")
    }
    
    static func main() { Today().run() }
}
