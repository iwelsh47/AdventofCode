//
//  testhandling.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

public func runTest<ReturnT: LosslessStringConvertible & Equatable>(
    _ testId: Int,
    _ scoredInput: String,
    _ testFunction: (String) -> ReturnT,
    scoreSeperator: String = " ") -> Bool {
        let testInput = scoredInput.components(separatedBy: scoreSeperator).first!
        let expectedOutput = ReturnT(scoredInput.components(separatedBy: scoreSeperator)[1])!
        let obtainedOutput = testFunction(testInput)
        if obtainedOutput != expectedOutput {
            print("Case \(testId) failed. Got \(obtainedOutput) but expected \(expectedOutput).")
            return false
        } else {
            return true
        }
    }

public func runTest<ReturnT: LosslessStringConvertible & Equatable, OptionalT>(
    _ testId: Int,
    _ scoredInput: String,
    _ optParameter: OptionalT,
    _ testFunction: (String, OptionalT) -> ReturnT,
    scoreSeperator: String = " ") -> Bool {
        let testInput = scoredInput.components(separatedBy: scoreSeperator).first!
        let expectedOutput = ReturnT(scoredInput.components(separatedBy: scoreSeperator)[1])!
        let obtainedOutput = testFunction(testInput, optParameter)
        if obtainedOutput != expectedOutput {
            print("Case \(testId) failed. Got \(obtainedOutput) but expected \(expectedOutput).")
            return false
        } else {
            return true
        }
    }


public func runTest<ReturnT: LosslessStringConvertible & Equatable, OptionalT: LosslessStringConvertible>(
    _ testId: Int,
    _ scoredInput: String,
    _ testFunction: (String, OptionalT) -> ReturnT,
    scoreSeperator: String = " ") -> Bool {
        let components: (String, String, String) = scoredInput.components(separatedBy: scoreSeperator).splat()
        let testInput = components.0
        let optParameter = OptionalT(components.1)!
        let expectedOutput = ReturnT(components.2)!
        let obtainedOutput = testFunction(testInput, optParameter)
        if obtainedOutput != expectedOutput {
            print("Case \(testId) failed. Got \(obtainedOutput) but expected \(expectedOutput).")
            return false
        } else {
            return true
        }
    }
