//
//  Day01.swift
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation

enum FacingDirection { 
    case north, east, south, west
    func turnLeft() -> FacingDirection {
        switch self {
            case .north: return .west
            case .east: return .north
            case .south: return .east
            case .west: return .south
        }
    }
    func turnRight() -> FacingDirection {
        switch self {
            case .north: return .east
            case .east: return .south
            case .south: return .west
            case .west: return .north
        }
    }
}

struct Location: Hashable {
    let x: Int
    let y: Int
    
    func step(in direction: FacingDirection, blocks: Int) -> Location {
        switch direction {
            case .north: return Location(x: x, y: y + blocks)
            case .east: return Location(x: x + blocks, y: y)
            case .south: return Location(x: x, y: y - blocks)
            case .west: return Location(x: x - blocks, y: y)
        }
    }
    
    func allSteps(in direction: FacingDirection, blocks: Int) -> [Location] {
        var locations = [Location]()
        for i in 1...blocks {
            switch direction {
                case .north: locations.append(Location(x: x, y: y + i))
                case .east:  locations.append(Location(x: x + i, y: y))
                case .south: locations.append(Location(x: x, y: y - i))
                case .west:  locations.append(Location(x: x - i, y: y))
            }
        }
        return locations
    }
}

@main final class Today: Day {
    init() { super.init(day: 1, year: 2016) }
    
    func followDirections(from directions: String) -> Location {
        var location = Location(x: 0, y: 0)
        var facing = FacingDirection.north
        for step in directions.components(separatedBy: ", ") {
            let turn = step.first!
            let blocks = Int(step[step.index(after: step.startIndex)..<step.endIndex])!
            facing = (turn == "L") ? facing.turnLeft() : facing.turnRight()
            location = location.step(in: facing, blocks: blocks)
        }
        return location
    }
    
    func followDirectionsUntilIntersection(from directions: String) -> Location? {
        var currentLocation = Location(x: 0, y: 0)
        var visitedLocations = Set([currentLocation])
        var facing = FacingDirection.north
        for step in directions.components(separatedBy: ", ") {
            let turn = step.first!
            let blocks = Int(step[step.index(after: step.startIndex)..<step.endIndex])!
            facing = (turn == "L") ? facing.turnLeft() : facing.turnRight()
            let allPointsVisited = currentLocation.allSteps(in: facing, blocks: blocks)
            let previouslyVisited = allPointsVisited.filter({ visitedLocations.contains($0) })
            if previouslyVisited.isNotEmpty { return previouslyVisited.first! }
            visitedLocations.formUnion(allPointsVisited)
            currentLocation = allPointsVisited.last!
        }
        return nil
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let finishLocation = followDirections(from: data)
        let distance = abs(finishLocation.x) + abs(finishLocation.y)
        print("Following instructions ends up at \(finishLocation) which is \(distance) blocks from the start")
        if let intersectLocation = followDirectionsUntilIntersection(from: data) {
            let distanceToIntersect = abs(intersectLocation.x) + abs(intersectLocation.y)
            print("Location of first intersection is at \(intersectLocation) which is \(distanceToIntersect) blocks away.")
        } else {
            print("Path does not intersect")
        }
    }
    
    static func main() { Today().run() }
}
