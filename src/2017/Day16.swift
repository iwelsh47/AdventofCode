//
//  Day16.swift
//  Day16_2017
//
//  Created by Ivan Welsh on 06/05/2024.
//

import Foundation

protocol Step {
    func apply(to people: inout [Character])
}

struct Spin : Step {
    let X: Int
    func apply(to people: inout [Character]) {
        let newFront = people[(people.count - X)..<people.count]
        let newBack = people[0..<(people.count - X)]
        people = newFront.map{$0} + newBack.map{$0}
    }
}

struct Exchange : Step {
    let A: Int
    let B: Int
    func apply(to people: inout [Character]) { people.swapAt(A, B) }
}

struct Partner : Step {
    let A: Character
    let B: Character
    func apply(to people: inout [Character]) {
        let iA = people.firstIndex(of: A)!
        let iB = people.firstIndex(of: B)!
        people.swapAt(iA, iB)
    }
}

func createStep(from str: String) -> Step {
    var chars = str.map{$0}.reversed().map{$0}
    
    switch chars.popLast()! {
        case "s":
            return Spin(X: Int(chars.reversed().map{String($0)}.joined())!)
        case "x":
            let (A, B) = chars.reversed().map{String($0)}.joined().components(separatedBy: "/").map{ Int($0)! }.splat()
            return Exchange(A: A, B: B)
        case "p":
            return Partner(A: chars.reversed()[0],
                           B: chars.reversed()[2])
        default:
            return Spin(X: 0)
    }
}

func dance(people: String, steps: [Step]) -> String {
    var individuals = people.map{ $0 }
    for step in steps { step.apply(to: &individuals) }
    return individuals.map{ String($0) }.joined()
}

@main final class Today: Day {
    init() { super.init(day: 16, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let steps = data.components(separatedBy: ",").map{ createStep(from: $0) }
        print("Final configuration after dance is \(dance(people: "abcdefghijklmnop", steps: steps))")
        
        // Determine number of loops to get back to start
        var people = "abcdefghijklmnop"
        var loopCount = 0
        repeat {
            people = dance(people: people, steps: steps)
            loopCount += 1
        } while people != "abcdefghijklmnop"
        print("Steps to get back to initial conditions = \(loopCount)")
        
        // Apply to 1e9
        let numSteps = 1_000_000_000 % loopCount
        for _ in 0..<numSteps {
            people = dance(people: people, steps: steps)
        }
        print("After 1 billion, configuration is \(people)")
    }
    
    static func main() { Today().run() }
}
