//
//  Day11.swift
//  Day11_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation
import Algorithms
import Collections

enum Element {
    case H, Li, Tm, Pu, Sr, Pm, Ru, El, Di
}

struct Floor {
    var rtgs = [Element]() // What RTGs are on the floor
    var microchips = [Element]() // What microchips are on the floor
    
    var isSafe: Bool {
        get {
            let nonMatchedChips = microchips.filter({ !rtgs.contains($0) })
            if nonMatchedChips.count == 0 { return true }
            return rtgs.count == 0
        }
    }
    
    var key: UInt16 {
        get {
            var keyValue = UInt16.zero
            let shiftValue = UInt16(1)
            
            for rtg in rtgs {
                switch rtg {
                    case .H: keyValue += shiftValue  << 0
                    case .Li: keyValue += shiftValue << 1
                    case .Tm: keyValue += shiftValue << 0
                    case .Pu: keyValue += shiftValue << 1
                    case .Sr: keyValue += shiftValue << 2
                    case .Pm: keyValue += shiftValue << 3
                    case .Ru: keyValue += shiftValue << 4
                    case .El: keyValue += shiftValue << 5
                    case .Di: keyValue += shiftValue << 6
                }
            }
            
            for microchip in microchips {
                switch microchip {
                    case .H: keyValue += shiftValue  << 2
                    case .Li: keyValue += shiftValue << 3
                    case .Tm: keyValue += shiftValue << 7
                    case .Pu: keyValue += shiftValue << 8
                    case .Sr: keyValue += shiftValue << 9
                    case .Pm: keyValue += shiftValue << 10
                    case .Ru: keyValue += shiftValue << 11
                    case .El: keyValue += shiftValue << 12
                    case .Di: keyValue += shiftValue << 13
                }
            }
            
            return keyValue
        }
    }
    
    var isEmpty: Bool {
        get {
            return rtgs.isEmpty && microchips.isEmpty
        }
    }
    
    func loseComponent(rtg: [Element], microchip: [Element]) -> Floor {
        return Floor(rtgs: self.rtgs.filter({ !rtg.contains($0) }),
                     microchips: self.microchips.filter({ !microchip.contains($0) }))
    }
    
    func gainComponent(rtg: [Element], microchip: [Element]) -> Floor {
        return Floor(rtgs: self.rtgs + rtg, microchips: self.microchips + microchip)
    }
}

struct Building {
    var floors = [Floor]() // The floors of the building
    var elevator = 0 // What floor the lift is on. Add 1 to get numerical floor number
    var stepNumber = 0
    
    var isSafe: Bool {
        get {
            return floors.allSatisfy({ $0.isSafe })
        }
    }
    
    var isDone: Bool {
        get {
            return elevator == 3 && floors.filter({ $0.isEmpty }).count == 3
        }
    }
    
    var key: UInt64 {
        get {
            return UInt64(floors[0].key) + (UInt64(floors[1].key) << 15) +
            (UInt64(floors[2].key) << 30) + (UInt64(floors[3].key) << 45) + (UInt64(elevator) << 60)
        }
    }
    
    func possibleMoves(seenLayouts: Set<UInt64>) -> [Building] {
        var moveOutcomes = [Building]()
        let numRTG = floors[elevator].rtgs.count
        let numChip = floors[elevator].microchips.count
        moveOutcomes.reserveCapacity( 2 * ( numRTG * numRTG + numChip * numChip + numRTG * numChip + 1 ))
        for delta in [-1, 1] {
            if delta == -1 && elevator == 0 { continue }
            if delta == 1 && elevator == 3 { continue }
            // Single/Double RTG
            for rtgs in self.floors[elevator].rtgs.combinations(ofCount: 1...2) {
                var newFloors = floors
                let floorCurrent = newFloors[elevator].loseComponent(rtg: rtgs, microchip: [])
                if !floorCurrent.isSafe { continue }
                let floorUp = newFloors[elevator + delta].gainComponent(rtg: rtgs, microchip: [])
                if !floorUp.isSafe { continue }
                newFloors[elevator] = floorCurrent
                newFloors[elevator + delta] = floorUp
                moveOutcomes.append(Building(floors: newFloors, elevator: elevator + delta, stepNumber: stepNumber + 1))
            }
            // Single/Double MC
            for microchips in self.floors[elevator].microchips.combinations(ofCount: 1...2) {
                var newFloors = floors
                let floorCurrent = newFloors[elevator].loseComponent(rtg: [], microchip: microchips)
                if !floorCurrent.isSafe { continue }
                let floorUp = newFloors[elevator + delta].gainComponent(rtg: [], microchip: microchips)
                if !floorUp.isSafe { continue }
                newFloors[elevator] = floorCurrent
                newFloors[elevator + delta] = floorUp
                moveOutcomes.append(Building(floors: newFloors, elevator: elevator + delta, stepNumber: stepNumber + 1))
            }
            // MC+RTG
            for microchip in self.floors[elevator].microchips {
                for rtg in self.floors[elevator].rtgs {
                    var newFloors = floors
                    let floorCurrent = newFloors[elevator].loseComponent(rtg: [rtg], microchip: [microchip])
                    if !floorCurrent.isSafe { continue }
                    let floorUp = newFloors[elevator + delta].gainComponent(rtg: [rtg], microchip: [microchip])
                    if !floorUp.isSafe { continue }
                    newFloors[elevator] = floorCurrent
                    newFloors[elevator + delta] = floorUp
                    moveOutcomes.append(Building(floors: newFloors, elevator: elevator + delta, stepNumber: stepNumber + 1))
                }
            }
        }
        
        return moveOutcomes.filter({ !seenLayouts.contains($0.key) })
    }
}

@main final class Today: Day {
    init() { super.init(day: 11, year: 2016) }
    
    func movesToReachDone(building: Building) -> Int {
        var possibleBuildings = Deque([building])
        possibleBuildings.reserveCapacity(200000)
        
        var seenLayouts = Set([building.key])
        while possibleBuildings.isNotEmpty {
            let b = possibleBuildings.popFirst()!
            if b.isDone {
                possibleBuildings.prepend(b)
                break
            }
            let newBuildings = b.possibleMoves(seenLayouts: seenLayouts)
            seenLayouts.formUnion(newBuildings.map({ $0.key }))
            possibleBuildings.append(contentsOf: newBuildings)
        }
        return possibleBuildings.first!.stepNumber
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let testBuilding = Building(floors: [Floor(microchips: [.H, .Li]),
                                             Floor(rtgs: [.H]),
                                             Floor(rtgs: [.Li]),
                                             Floor()])
        
        let inputBuilding = Building(floors: [Floor(rtgs: [.Tm, .Pu, .Sr], microchips: [.Tm]),
                                              Floor(microchips: [.Pu, .Sr]),
                                              Floor(rtgs: [.Pm, .Ru], microchips: [.Pm, .Ru]),
                                              Floor()])
        
        let realBuilding = Building(floors: [Floor(rtgs: [.Tm, .Pu, .Sr, .Di, .El], microchips: [.Tm, .Di, .El]),
                                              Floor(microchips: [.Pu, .Sr]),
                                              Floor(rtgs: [.Pm, .Ru], microchips: [.Pm, .Ru]),
                                              Floor()])
        
        print("To complete test takes \(movesToReachDone(building: testBuilding)) steps")
        print("To complete part 1 takes \(movesToReachDone(building: inputBuilding)) steps")
        print("To complete part 2 takes \(movesToReachDone(building: realBuilding)) steps")
    }
    
    static func main() { Today().run() }
}
