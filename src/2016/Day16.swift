//
//  Day16.swift
//  Day16_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation

func applyDragonCurve(to str: String) -> [Bool] {
    return applyDragonCurve(to: str.map{ $0 == "0" ? false : true })
}

func applyDragonCurve(to str: [Bool]) -> [Bool] {
    let a = str
    let b = a.reversed().map{ !$0 }
    return a + [false] + b
}

func checkSum(of str: [Bool]) -> String {
    var checksum = [Bool]()
    checksum.reserveCapacity((str.count + 1) / 2)
    for index in stride(from: 0, to: str.count, by: 2) {
        if str[index] == str[index + 1] { checksum.append(true) }
        else { checksum.append(false) }
    }
    if checksum.count.isMultiple(of: 2) { return checkSum(of: checksum) }
    else { return checksum.map{ $0 ? "1" : "0" }.joined() }
}

@main final class Today: Day {
    init() { super.init(day: 16, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let input = "10010000000110000"
        for (n, desiredLength) in [272, 35651584].enumerated() {
            var fillingDisk = applyDragonCurve(to: input)
            while fillingDisk.count < desiredLength { fillingDisk = applyDragonCurve(to: fillingDisk) }
            fillingDisk.removeLast(fillingDisk.count - desiredLength)
            print("Checksum \(n + 1) is \(checkSum(of: fillingDisk))")
        }
        
    }
    
    static func main() { Today().run() }
}
