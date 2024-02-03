//
//  Day25.swift
//  Day25_2016
//
//  Created by Ivan Welsh on 3/02/24.
//

import Foundation


@main final class Today: Day {
    init() { super.init(day: 25, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var aValue = 1
        while true {
            let instructions = InstructionSet(from: data)
            let works = instructions.follow(memory: [.a: aValue], until: [0,1,0,1,0,1,0,1,0,1,0,1])
            if works ?? false { break }
            aValue += 1
        }
        print("Lowest usable value is \(aValue)")
    }
    
    static func main() { Today().run() }
}
