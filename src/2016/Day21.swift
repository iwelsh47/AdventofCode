//
//  Day21.swift
//  Day21_2016
//
//  Created by Ivan Welsh on 28/01/24.
//

import Foundation

enum Operation: Int {
    case swapPosition = 0, swapLetter, rotateLeft, rotateRight, rotatePosition, reverse, move,
         rSwapPosition, rSwapLetter, rRotateLeft, rRotateRight, rRotatePosition, rReverse, rMove
    
    static func parse(_ str: String) -> Operation {
        if str.hasPrefix("swap position") { return .swapPosition }
        if str.hasPrefix("swap letter") { return .swapLetter }
        if str.hasPrefix("rotate left") { return .rotateLeft }
        if str.hasPrefix("rotate right") { return .rotateRight }
        if str.hasPrefix("rotate based") { return .rotatePosition }
        if str.hasPrefix("reverse") { return .reverse }
        return .move
    }
}

func process(instruction: String, on password: inout [Character], inReverse: Bool = false) {
    var operation = Operation.parse(instruction)
    if inReverse {
        operation = Operation(rawValue: operation.rawValue + Operation.rSwapPosition.rawValue)!
    }
    let bits = instruction.components(separatedBy: " ")
    switch operation {
        case .rSwapPosition: fallthrough
        case .swapPosition: swap(x: Int(bits[2])!, y: Int(bits[5])!, password: &password)
        case .rSwapLetter: fallthrough
        case .swapLetter: swap(x: Character(bits[2]), y: Character(bits[5]), password: &password)
        case .rReverse: fallthrough
        case .reverse: reverse(from: Int(bits[2])!, to: Int(bits[4])!, password: &password)
        case .rotateLeft: fallthrough
        case .rotateRight: rotate(direction: operation, x: Int(bits[2])!, password: &password)
        case .rRotateLeft: rotate(direction: .rotateRight, x: Int(bits[2])!, password: &password)
        case .rRotateRight: rotate(direction: .rotateLeft, x: Int(bits[2])!, password: &password)
        case .rRotatePosition: reverseRotate(x: Character(bits[6]), password: &password)
        case .rotatePosition: rotate(x: Character(bits[6]), password: &password)
        case .move: move(x: Int(bits[2])!, y: Int(bits[5])!, password: &password)
        case .rMove: move(x: Int(bits[5])!, y: Int(bits[2])!, password: &password)
    }
}

// swap position X with position Y
func swap(x: Int, y: Int, password: inout [Character]) { password.swapAt(x, y) }
// swap letter X with letter Y
func swap(x: Character, y: Character, password: inout [Character]) {
    for (i, char) in password.enumerated() {
        if char == x { password[i] = y }
        else if char == y { password[i] = x }
    }
}
// reverse positions X through Y
func reverse(from x: Int, to y: Int, password: inout [Character]) {
    var leftPos = x
    var rightPos = y
    while leftPos < rightPos {
        password.swapAt(leftPos, rightPos)
        leftPos += 1
        rightPos -= 1
    }
}
// rotate left/right X steps
func rotate(direction: Operation, x: Int, password: inout [Character]) {
    let swapFrom = password
    var swapIdx = direction == .rotateLeft ? x : (password.count - x) % password.count
    for i in 0..<password.count {
        password[i] = swapFrom[swapIdx]
        swapIdx = (swapIdx + 1) % password.count
    }
}

// rotate based on position of letter X
func rotate(x: Character, password: inout [Character]) {
    let idx = password.firstIndex(of: x)!
    let steps = (1 + idx + (idx >= 4 ? 1 : 0)) % password.count
    rotate(direction: .rotateRight, x: steps, password: &password)
}

func reverseRotate(x: Character, password: inout [Character]) {
    let idx = password.firstIndex(of: x)!
    switch idx {
        case 0: rotate(direction: .rotateLeft, x: 1, password: &password)
        case 1: rotate(direction: .rotateLeft, x: 1, password: &password)
        case 2: rotate(direction: .rotateLeft, x: 6, password: &password)
        case 3: rotate(direction: .rotateLeft, x: 2, password: &password)
        case 4: rotate(direction: .rotateLeft, x: 7, password: &password)
        case 5: rotate(direction: .rotateLeft, x: 3, password: &password)
        case 6: rotate(direction: .rotateLeft, x: 0, password: &password)
        case 7: rotate(direction: .rotateLeft, x: 4, password: &password)
        default: return
    }
}

// move position X to position Y
func move(x: Int, y: Int, password: inout [Character]) {
    let xChar = password.remove(at: x)
    password.insert(xChar, at: y)
}

@main final class Today: Day {
    init() { super.init(day: 21, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var password = "abcdefgh".map{ $0 }
        for instruct in data.components(separatedBy: "\n") {
            process(instruction: instruct, on: &password)
        }
        print("Scrambled password is \(password.map{String($0)}.joined())")
        
        password = "fbgdceah".map{ $0 }
        for instruct in data.components(separatedBy: "\n").reversed() {
            process(instruction: instruct, on: &password, inReverse: true)
        }
        print("Unscrambled password is \(password.map{String($0)}.joined())")
    }
    
    static func main() { Today().run() }
}
