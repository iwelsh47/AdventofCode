//
//  Day21.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

protocol CombatItem {
    var name: String { get }
    var cost: Int { get }
    var damage: Int { get }
    var armour: Int { get }
    
    init(description: String)
}

fileprivate func descriptionToItems(from description: String) -> (name: String, cost: Int, damage: Int, armour: Int) {
    let bits = description.components(separatedBy: " ")
    let name = bits[0]
    let cost = Int(bits[1])!
    let damage = Int(bits[2])!
    let armour = Int(bits[3])!
    return (name, cost, damage, armour)
}

struct Weapon: CombatItem {
    let name: String
    let cost: Int
    let damage: Int
    let armour: Int
    init(description: String) {
        (name, cost, damage, armour) = descriptionToItems(from: description)
    }
}

struct Armour: CombatItem {
    let name: String
    let cost: Int
    let damage: Int
    let armour: Int
    init(description: String) {
        (name, cost, damage, armour) = descriptionToItems(from: description)
    }
}

struct Ring: CombatItem {
    let name: String
    let cost: Int
    let damage: Int
    let armour: Int
    init(description: String) {
        (name, cost, damage, armour) = descriptionToItems(from: description)
    }
}

struct Player {
    var health: Int
    let loadout: [CombatItem]
    
    func damagePerTurn(against enemy: Player) -> Int {
        let myDamage = loadout.reduce(0, { $0 + $1.damage })
        let enemyArmour = enemy.loadout.reduce(0, { $0 + $1.armour })
        return max(1, myDamage - enemyArmour)
    }
    
    func turnsToKill(enemy: Player) -> Int {
        let closeTurns = enemy.health.quotientAndRemainder(dividingBy: damagePerTurn(against: enemy))
        return closeTurns.quotient + (closeTurns.remainder > 0 ? 1 : 0)
    }
    
    func costOfLoadout() -> Int {
        return loadout.reduce(0, {$0 + $1.cost})
    }
}

@main final class Today: Day {
    let weapons: [Weapon]
    let armours: [Armour]
    let rings: [Ring]
    
    init() {
        weapons = """
                Dagger 8 4 0
                Shortsword 10 5 0
                Warhammer 25 6 0
                Longsword 40 7 0
                Greataxe 74 8 0
                """.components(separatedBy: "\n").map({ Weapon(description: $0.trimmed()) })
        
        armours = """
                Nothing 0 0 0
                Leather 13 0 1
                Chainmail 31 0 2
                Splintmail 53 0 3
                Bandedmail 75 0 4
                Platemail 102 0 5
                """.components(separatedBy: "\n").map({ Armour(description: $0.trimmed()) })
        
        rings = """
                Nothing1 0 0 0
                Nothing2 0 0 0
                Damage+1 25 1 0
                Damage+2 50 2 0
                Damage+3 100 3 0
                Defense+1 20 0 1
                Defense+2 40 0 2
                Defense+3 80 0 3
                """.components(separatedBy: "\n").map({ Ring(description: $0.trimmed())})
        super.init(day: 21, year: 2015)
    }
    
    enum PlayerCharacter { case Player, Enemy }
    enum CostTarget { case High, Low }
    
    func winnerBetween(player: Player, enemy: Player) -> PlayerCharacter {
        // Player always go first, so if turns to kill for player is <= turns to kill for enemy
        return player.turnsToKill(enemy: enemy) <= enemy.turnsToKill(enemy: player) ? .Player : .Enemy
    }
    
    func bestCostFor(winner toWin: PlayerCharacter,
                     aimingFor target: CostTarget,
                     against enemy: Player) -> (Int, [CombatItem]) {
        var bestCost = target == .Low ? Int.max : 0
        var bestLoadOut = [CombatItem]()
        for weapon in weapons {
            for armour in armours {
                for ring1 in rings {
                    for ring2 in rings.filter({ $0.name != ring1.name }) {
                        let player = Player(health: 100, loadout: [weapon, armour, ring1, ring2])
                        let loadoutCost = player.costOfLoadout()
                        let fightWinner = winnerBetween(player: player, enemy: enemy)
                        if fightWinner == toWin &&
                            ((target == .Low && loadoutCost < bestCost) ||
                             (target == .High && loadoutCost > bestCost)) {
                            bestCost = loadoutCost
                            bestLoadOut = player.loadout
                        }
                    }
                }
            }
        }
        return (bestCost, bestLoadOut)
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let boss = Player(health: 104, loadout: [weapons.last!, armours[1]])
        print("Best cost to beat the boss is \(bestCostFor(winner: .Player, aimingFor: .Low, against: boss))")
        print("Most spent to lose to the boss is \(bestCostFor(winner: .Enemy, aimingFor: .High, against: boss))")
    }
    
    static func main() { Today().run() }
}
