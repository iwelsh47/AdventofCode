//
//  Day22.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

struct Player {
    let name: PlayerType
    var health: Int
    var armour: Int
    var mana: Int
    var effects: [Effect]
    
    init(name: PlayerType, health: Int, armour: Int, mana: Int) {
        self.name = name
        self.health = health
        self.armour = armour
        self.mana = mana
        self.effects = [Effect]()
    }
    
    func activeEffectNames() -> [String] {
        return effects.filter({ $0.timer > 1 }).map({ $0.name })
    }
    
    mutating func tick() {
        var newEffects = [Effect]()
        var oldEffects = effects
        for idx in oldEffects.indices {
            if let newEffect = effects[idx].tick(on: &self) { newEffects.append(newEffect) }
        }
        effects = newEffects
    }
}

protocol Spell {
    var name: String { get }
    var manaCost: Int { get }
    var damage: Int? { get }
    var playerEffect: Effect? { get }
    var enemyEffect: Effect? { get }
    var healing: Int? { get }
    func cast(from player: inout Player, to enemy: inout Player)
}

extension Spell {
    func cast(from player: inout Player, to enemy: inout Player) {
        player.mana -= manaCost
        if let damage {
            let damageToDeal = max(damage - enemy.armour, 1)
            enemy.health -= damageToDeal
        }
        if let healing {
            player.health += healing
        }
        if let playerEffect {
            playerEffect.apply(to: &player)
        }
        if let enemyEffect {
            enemyEffect.apply(to: &enemy)
        }
    }
}

protocol Effect {
    var name: String { get }
    var timer: Int { get set }
    func apply(to target: inout Player)
    func end(on target: inout Player)
    func tick(on target: inout Player) -> Effect?
}

// Magic Missile costs 53 mana. It instantly does 4 damage.
struct MagicMissile: Spell {
    let manaCost = 53
    let name = "Magic Missile"
    var damage: Int? = 4
    var playerEffect: Effect?
    var enemyEffect: Effect?
    var healing: Int?
}

// Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
struct Drain: Spell {
    let manaCost = 73
    let name = "Drain"
    var damage: Int? = 2
    var playerEffect: Effect?
    var enemyEffect: Effect?
    var healing: Int? = 2
}

// Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
struct Shield : Spell {
    let manaCost = 113
    let name = "Shield"
    var damage: Int?
    var playerEffect: Effect? = Shielded()
    var enemyEffect: Effect?
    var healing: Int?
}

struct Shielded : Effect {
    var timer = 6
    let name = "Shielded"
    let armourChange = 7
    
    func apply(to target: inout Player) {
        target.armour += armourChange
        target.effects.append(self)
    }
    
    func tick(on target: inout Player) -> Effect? {
        let newTimer = timer - 1
        if newTimer == 0 {
            end(on: &target)
            return nil
        } else {
            return Shielded(timer: newTimer)
        }
    }
    
    func end(on target: inout Player) {
        target.armour -= armourChange
    }
    
}

// Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active,
// it deals the boss 3 damage.
struct Poison : Spell {
    let manaCost = 173
    let name = "Poison"
    var damage: Int?
    var playerEffect: Effect?
    var enemyEffect: Effect? = Poisoned()
    var healing: Int?
}

struct Poisoned : Effect {
    var timer = 6
    let name = "Poisoned"
    let damage = 3
    
    func apply(to target: inout Player) {
        target.effects.append(self)
    }
    
    func tick(on target: inout Player) -> Effect? {
        let damageToDeal = max(damage - target.armour, 1)
        target.health -= damageToDeal
        
        let newTimer = timer - 1
        if newTimer == 0 {
            end(on: &target)
            return nil
        } else {
            return Poisoned(timer: newTimer)
        }
    }
    
    func end(on target: inout Player) {  }
}

// Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active,
// it gives you 101 new mana.
struct Recharge : Spell {
    let manaCost = 229
    let name = "Recharge"
    var damage: Int?
    var playerEffect: Effect? = Recharging()
    var enemyEffect: Effect?
    var healing: Int?
}

struct Recharging : Effect {
    var timer = 5
    let name = "Recharging"
    let manaHeal = 101
    
    func apply(to target: inout Player) {
        target.effects.append(self)
    }
    
    func tick(on target: inout Player) -> Effect? {
        target.mana += manaHeal
        
        let newTimer = timer - 1
        if newTimer == 0 {
            end(on: &target)
            return nil
        } else {
            return Recharging(timer: newTimer)
        }
    }
    
    func end(on target: inout Player) {  }
}

// Boss base attack
struct BossAttack : Spell {
    var manaCost = 0
    let name = "Attack"
    var damage: Int? = 9
    var playerEffect: Effect?
    var enemyEffect: Effect?
    var healing: Int?
}

// Player base attack
struct PlayerAttack : Spell {
    var manaCost = 0
    let name = "Skip turn"
    var damage: Int?
    var playerEffect: Effect?
    var enemyEffect: Effect?
    var healing: Int?
}

enum PlayerType { case player, boss }

@main final class Today: Day {
    
    let allSpells: [Spell] = [Recharge(), MagicMissile(), Shield(), Drain(), Poison()]
    
    init() { super.init(day: 22, year: 2015) }
    
    func performTurn(for player: inout Player, against enemy: inout Player, cast spellToCast: Spell, hardMode: Bool) -> PlayerType? {
        if hardMode && player.name == .player { player.health -= 1 }
        player.tick()
        if player.health <= 0 {
            return enemy.name
        }
        enemy.tick()
        if enemy.health <= 0 {
            return player.name
        }
        spellToCast.cast(from: &player, to: &enemy)
        if enemy.health <= 0 {
            return player.name
        }
        return nil
    }
    
    func performRound(player: inout Player, boss: inout Player, spell: Spell, hardMode: Bool) -> PlayerType? {
        if let winner = performTurn(for: &player, against: &boss, cast: spell, hardMode: hardMode) { return winner }
        if let winner = performTurn(for: &boss, against: &player, cast: BossAttack(), hardMode: hardMode) { return winner }
        return nil
    }
    
    func performSequence(player: Player, boss: Player, spells: [Spell], hardMode: Bool) -> (PlayerType?, Player?, Player?) {
        var localPlayer = player
        var localBoss = boss
        for spell in spells {
            if let winner = performRound(player: &localPlayer, boss: &localBoss, spell: spell, hardMode: hardMode) {
                return (winner, localPlayer, localBoss)
            }
        }
        return (nil, localPlayer, localBoss)
    }
    
    func validSpells(for player: Player, against enemy: Player) -> [Spell] {
        var validSpells = [Spell]()
        let activeEffects = player.activeEffectNames() + enemy.activeEffectNames()
        for spell in allSpells {
            if let playerEffect = spell.playerEffect { 
                if activeEffects.contains(playerEffect.name) { continue }
            }
            if let enemyEffect = spell.enemyEffect {
                if activeEffects.contains(enemyEffect.name) { continue }
            }
            if spell.manaCost > player.mana { continue }
            if spell.manaCost == 0 && player.mana >= 53 { continue }
            validSpells.append(spell)
        }
        return validSpells
    }
    
    func sequenceManaCost(sequence: [Spell]) -> Int { return sequence.reduce(0, { $0 + $1.manaCost }) }
    
    func runGame(hardMode: Bool = false) -> (Int, [Spell]) {
        var boss = Player(name: .boss, health: 58, armour: 0, mana: 0)
        var player = Player(name: .player, health: 50, armour: 0, mana: 500)
        
        var sequences = [[Spell]]()
        for spell in validSpells(for: player, against: boss) {
            sequences.append([spell])
        }
        
        var bestSequence = [Spell]()
        var bestCost = Int.max
        
        while !sequences.isEmpty {
            var sequence = sequences.popLast()!
            let seqCost = sequenceManaCost(sequence: sequence)
            if seqCost > bestCost { continue }
            
            let result = performSequence(player: player, boss: boss, spells: sequence, hardMode: hardMode)
            if let winner = result.0 {
                if winner == .boss { continue }
                if seqCost < bestCost {
                    bestCost = seqCost
                    bestSequence = sequence
                }
            } else {
                for spell in validSpells(for: result.1!, against: result.2!) {
                    if seqCost + spell.manaCost > bestCost { continue }
                    var newSequence = sequence
                    newSequence.append(spell)
                    sequences.append(newSequence)
                }
            }
        }
        
        return (bestCost, bestSequence)
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        let easyMode = runGame()
        print("Best cost is \(easyMode.0) for \(easyMode.1.map({$0.name}))")
        let hardMode = runGame(hardMode: true)
        print("Best cost for hard mode is \(hardMode.0) for \(hardMode.1.map({$0.name}))")
        
    }
    
    static func main() { Today().run() }
}

