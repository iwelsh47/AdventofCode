//
//  Day15.swift
//  Day15_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation
import Algorithms

protocol Ingredient {
    var capacity: Int { get }
    var durability: Int { get }
    var flavour: Int { get }
    var texture: Int { get }
    var calories: Int { get }
}

extension Ingredient {
    func capacityScore(amount: Int) -> Int   { amount * capacity }
    func durabilityScore(amount: Int) -> Int { amount * durability }
    func flavourScore(amount: Int) -> Int    { amount * flavour }
    func textureScore(amount: Int) -> Int    { amount * texture }
    func caloriesScore(amount: Int) -> Int   { amount * calories }
}

struct Sugar: Ingredient {
    let capacity: Int = 3
    let durability: Int = 0
    let flavour: Int = 0
    let texture: Int = -3
    let calories: Int = 2
}

struct Sprinkles: Ingredient {
    let capacity: Int = -3
    let durability: Int = 3
    let flavour: Int = 0
    let texture: Int = 0
    let calories: Int = 9
}

struct Candy: Ingredient {
    let capacity: Int = -1
    let durability: Int = 0
    let flavour: Int = 4
    let texture: Int = 0
    let calories: Int = 1
}

struct Chocolate: Ingredient {
    let capacity: Int = 0
    let durability: Int = 0
    let flavour: Int = -2
    let texture: Int = 2
    let calories: Int = 8
}

@main final class Today: Day {
    init() { super.init(day: 16, year: 2015) }
    
    func score(of amount: [Int], calorieTotal: Int? = nil) -> Int {
        let allIngredients: [Ingredient] = [Sugar(), Sprinkles(), Candy(), Chocolate()]
        var capacity = 0
        var durability = 0
        var flavour = 0
        var texture = 0
        var calories = 0
        
        for index in 0..<amount.count {
            capacity += allIngredients[index].capacityScore(amount: amount[index])
            durability += allIngredients[index].durabilityScore(amount: amount[index])
            flavour += allIngredients[index].flavourScore(amount: amount[index])
            texture += allIngredients[index].textureScore(amount: amount[index])
            calories += allIngredients[index].caloriesScore(amount: amount[index])
        }
        if let calorieTotal, calories != calorieTotal { return 0 }
        return max(0, capacity) * max(0, durability) * max(0, flavour) * max(0, texture)
    }
    
    func bestScore(from teaspoons: Int,
                   havingCalories calorieTotal: Int? = nil,
                   ingredients number: Int = 4) -> (score: Int, mixture: [Int]) {
        var bestScore = Int.min
        var bestRecipe = [Int]()
        for recipe in allCombinations(ofLength: number, from: 0, to: teaspoons) {
            let recipeScore = score(of: recipe, calorieTotal: calorieTotal)
            if recipeScore > bestScore {
                bestScore = recipeScore
                bestRecipe = recipe
            }
        }
        return (score: bestScore, mixture: bestRecipe)
    }
    
    func allCombinations(ofLength length: Int, from: Int, to: Int) -> [[Int]] {
        if length == 0 { return [[Int]()]}
        if length == 1 { return [[to]] }
        var combos = [[Int]]()
        for i in from...to {
            for subCombo in allCombinations(ofLength: length - 1, from: from, to: to - i) {
                combos.append(subCombo)
                combos[combos.count - 1].append(i)
            }
        }
        return combos
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        var bestUnlimited = bestScore(from: 100)
        print("Highest scoring cookie is \(bestUnlimited.score) with \(bestUnlimited.mixture).")
        var best500 = bestScore(from: 100, havingCalories: 500)
        print("Highest scoring 500 calorie cookie is \(best500.score) with \(best500.mixture)")
    }
    
    static func main() { Today().run() }
}
