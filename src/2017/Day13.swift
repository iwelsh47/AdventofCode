//
//  Day13.swift
//  Day13_2017
//
//  Created by Ivan Welsh on 05/05/2024.
//

import Foundation

struct LayerScanner {
    let range: Int
    var location: Int = 0
    var delta = -1
    
    init(range: Int) {
        self.range = range
    }
    
    mutating func stepForward() {
        if location == 0 || location == (range - 1) { delta *= -1 }
        location += delta
    }
    
    mutating func delay(amount: Int) {
        location = amount % cycleLength
        if location >= range {
            location = range + (range - location) - 2
            delta = -1
        } else {
            delta = location == 0 ? -1 : 1
        }
    }
    
    func locationInfo() -> String {
        var cells = repeatElement("_", count: range).map{$0}
        cells[location] = "S"
        cells.append(contentsOf: ["  \(cycleLength)"])
        return cells.joined()
    }
    
    var cycleLength: Int { get {return (range - 1) * 2 } }
}

func getSeverity(startTime: Int, scanners: [Int: LayerScanner], catchOnly: Bool = false) -> (Bool, Int) {
    var severity = 0
    var myLocation = -1
    var layers = scanners
    
    for key in layers.keys { layers[key]!.delay(amount: startTime) }
    var caught = false
    while myLocation < layers.keys.max()! {
        myLocation += 1
        if layers[myLocation]?.location == 0 {
            severity += myLocation * layers[myLocation]!.range
            caught = true
            if catchOnly { break }
        }
        for key in layers.keys { layers[key]!.stepForward() }
    }
    return (caught, severity)
}

@main final class Today: Day {
    init() { super.init(day: 13, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var layers = [Int: LayerScanner]()
        
        for l in data.components(separatedBy: .newlines) {
            let (depth, range) = l.components(separatedBy: ": ").splat()
            layers.updateValue(LayerScanner(range: Int(range)!), forKey: Int(depth)!)
        }
        
        print("Non wait severity is \(getSeverity(startTime: 0, scanners: layers))")
        
        var delay = 0
        while true {
            let (caught, _) = getSeverity(startTime: delay, scanners: layers, catchOnly: true)
            if !caught { break }
            else { delay += 1 }
        }
        
        print("First wait time for non detection is \(delay)")
        
    }
    
    static func main() { Today().run() }
}
