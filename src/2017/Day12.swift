//
//  Day12.swift
//  Day12_2017
//
//  Created by Ivan Welsh on 6/02/24.
//

import Foundation

struct AdjacencyGraph {
    var adjaceny = [Int: [Int]]()
    init(from str: String) {
        for program in str.components(separatedBy: .newlines) {
            let (id, nbrs) = program.components(separatedBy: " <-> ").splat()
            adjaceny.updateValue(nbrs.components(separatedBy: ", ").map{ Int($0)! }, forKey: Int(id)!)
        }
    }
    
    func component(containing x: Int) -> [Int] {
        var component = [Int]()
        var toCheck = Set([x])
        while toCheck.isNotEmpty {
            let id = toCheck.popFirst()!
            component.append(id)
            toCheck.formUnion(adjaceny[id]!.filter{ !component.contains($0) })
        }
        return component
    }
    
    func connectedComponents() -> [[Int]] {
        var components = [[Int]]()
        var allKeys = Set(adjaceny.keys)
        while allKeys.isNotEmpty {
            var component = [Int]()
            var toCheck = Set([allKeys.popFirst()!])
            while toCheck.isNotEmpty {
                let id = toCheck.popFirst()!
                component.append(id)
                toCheck.formUnion(adjaceny[id]!.filter{ !component.contains($0) })
            }
            components.append(component)
            allKeys.subtract(component)
        }
        return components
    }
}

@main final class Today: Day {
    init() { super.init(day: 12, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var adjaceny = AdjacencyGraph(from: data)
        
        print("There are \(adjaceny.component(containing: 0).count) programs in the 0'th component.")
        print("There are \(adjaceny.connectedComponents().count) groups.")
        
    }
    
    static func main() { Today().run() }
}

