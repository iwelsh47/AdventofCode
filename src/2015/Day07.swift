//
//  Day07.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

@main final class Today: Day {
    init() { super.init(day: 7, year: 2015)}
    /*
     This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates! Unfortunately, little Bobby is
     a little under the recommended age range, and he needs help assembling the circuit.
     
     Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number from 0 to 65535). A
     signal is provided to each wire by a gate, another wire, or some specific value. Each wire can only get a signal
     from one source, but can provide its signal to multiple destinations. A gate provides no signal until all of its
     inputs have a signal.
     
     The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires 
     x and y to an AND gate, and then connect its output to wire z.
     
     For example:
     
     123 -> x means that the signal 123 is provided to wire x.
     x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
     p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
     NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
     
     Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate 
     the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for these gates.
     
     For example, here is a simple circuit:
     
     123 -> x
     456 -> y
     x AND y -> d
     x OR y -> e
     x LSHIFT 2 -> f
     y RSHIFT 2 -> g
     NOT x -> h
     NOT y -> i
     
     After it is run, these are the signals on the wires:
     
     d: 72
     e: 507
     f: 492
     g: 114
     h: 65412
     i: 65079
     x: 123
     y: 456
     
     In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?
     */
    
    struct BitwiseState {
        var gateState: [String: UInt16]
        
        init(circuit: String) {
            gateState = Dictionary<String, UInt16>()
            handleInstructions(from: circuit, fixedB: false)
        }
        
        mutating func handleInstructions(from circuit: String, fixedB: Bool) {
            var instructions = circuit.components(separatedBy: "\n")
            var stillToDo = Array<String>()
            
            while !instructions.isEmpty {
                for instruction in instructions {
                    let components = instruction.components(separatedBy: " ")
                    if fixedB && components.last! == "b" { continue }
                    if components.count == 3 {
                        // Simple assignment
                        if let valueToAssign = UInt16(components.first!) ?? gateState[components.first!] {
                            gateState.updateValue(valueToAssign, forKey: components.last!)
                        } else { stillToDo.append(instruction) }
                    } else if components.count == 4 {
                        // Bitwise complement
                        if let valueToAssign = UInt16(components[1]) ?? gateState[components[1]] {
                            gateState.updateValue(~valueToAssign, forKey: components.last!)
                        } else { stillToDo.append(instruction) }
                    } else {
                        guard let lhsValue = UInt16(components.first!) ?? gateState[components.first!]
                        else { stillToDo.append(instruction); continue }
                        guard let rhsValue = UInt16(components[2]) ?? gateState[components[2]]
                        else { stillToDo.append(instruction); continue }
                        
                        switch components[1] {
                            case "AND": gateState.updateValue(lhsValue & rhsValue, forKey: components.last!)
                            case "OR" : gateState.updateValue(lhsValue | rhsValue, forKey: components.last!)
                            case "LSHIFT": gateState.updateValue(lhsValue << rhsValue, forKey: components.last!)
                            case "RSHIFT": gateState.updateValue(lhsValue >> rhsValue, forKey: components.last!)
                            default: continue
                        }
                    }
                }
                instructions.removeAll(keepingCapacity: true)
                instructions.append(contentsOf: stillToDo)
                stillToDo.removeAll(keepingCapacity: true)
            }
        }
    }
    
    /*
     Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire
     a). What new signal is ultimately provided to wire a?
     */
    
    override func run() {
        print("Running \(year), day \(day)")
        var initialState = BitwiseState(circuit: data)
        let aValue = initialState.gateState["a"]!
        print("Following the circuit gives final state of a as \(aValue)")
        
        initialState.gateState.removeAll()
        initialState.gateState.updateValue(aValue, forKey: "b")
        initialState.handleInstructions(from: data, fixedB: true)
        let newAValue = initialState.gateState["a"]!
        print("Fixing b to this value and re-running gives the final state of a as \(newAValue)")
    }
    
    static func main() { Today().run() }
}
