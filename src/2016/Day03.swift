//
//  Day03.swift
//  Day03_2016
//
//  Created by Ivan Welsh on 18/01/24.
//

import Foundation

struct Triangle {
    let a: Int
    let b: Int
    let c: Int
    
    init(_ a: Int, _ b: Int, _ c: Int) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    init(from info: String) {
        (self.a, self.b , self.c) = info.split(separator: " ").map({ Int($0)! }).splat()
    }
    
    static func fromColumns(row1: String, row2: String, row3: String) -> [Triangle] {
        let (a1, a2, a3) = row1.split(separator: " ").map({ Int($0)! }).splat()
        let (b1, b2, b3) = row2.split(separator: " ").map({ Int($0)! }).splat()
        let (c1, c2, c3) = row3.split(separator: " ").map({ Int($0)! }).splat()
        return [Triangle(a1, b1, c1), Triangle(a2, b2, c2), Triangle(a3, b3, c3)]
    }
    
    var isValid: Bool {
        get {
            return (a + b + c - max(a, b, c)) > max(a, b, c)
        }
    }
}

@main final class Today: Day {
    init() { super.init(day: 3, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let triangles = data.components(separatedBy: "\n").map({ Triangle(from: $0) })
        print("Number of valid triangles is \(triangles.filter({ $0.isValid }).count)")
        let triangeInfo = data.split(separator: "\n")
        var colTriangles = [Triangle]()
        for i in stride(from: 0, to: triangeInfo.count, by: 3) {
            colTriangles.append(contentsOf: Triangle.fromColumns(row1: String(triangeInfo[i]),
                                                                 row2: String(triangeInfo[i+1]),
                                                                 row3: String(triangeInfo[i+2])))
        }
        print("Number of valid column triangles is \(colTriangles.filter({ $0.isValid }).count)")
    }
    
    static func main() { Today().run() }
}
