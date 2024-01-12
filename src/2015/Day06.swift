//
//  Day06.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

@main final class Today: Day {
    init() { super.init(day: 6, year: 2015)}
    /*
     Because your neighbors keep defeating you in the holiday house decorating contest year after year, you've decided 
     to deploy one million lights in a 1000x1000 grid.
     
     Furthermore, because you've been especially nice this year, Santa has mailed you instructions on how to display the
     ideal lighting configuration.
     
     Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999, 
     999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given
     as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair
     like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.
     
     To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent 
     you in order.
     
     For example:
     
     turn on 0,0 through 999,999 would turn on (or leave on) every light.
     toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, 
     and turning on the ones that were off.
     turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
     
     After following the instructions, how many lights are lit?
     */
    
    struct ToggleableLights {
        var lights: [[Bool]]
        init(numX: Int, numY: Int, startState: Bool) {
            self.lights = Array(repeating: Array(repeating: startState, count: numX), count: numY)
        }
        
        func numberLit() -> Int {
            return lights.reduce(0, { $0 + $1.filter({ $0 }).count})
        }
        
        mutating func toggleLights(_ startX: Int, _ startY: Int, _ endX: Int, _ endY: Int, to: Bool?) {
            for x in startX...endX {
                for y in startY...endY {
                    if let newVal = to {
                        lights[x][y] = newVal
                    } else {
                        lights[x][y].toggle()
                    }
                }
            }
        }
    }
    
    func animateLights(using pattern: String, startState: Bool = false) -> Int {
        var lightGrid = ToggleableLights(numX: 1000, numY: 1000, startState: startState)
        for step in pattern.components(separatedBy: "\n") {
            let stepComponents = step.components(separatedBy: " ")
            let i = stepComponents.first == "turn" ? 2 : 1
            let toggleTo = stepComponents.first == "turn" ? (stepComponents[1] == "on") : nil
            
            let (startX, startY) = stepComponents[i].components(separatedBy: ",").map({Int($0)!}).splat()
            let (endX, endY) = stepComponents[i+2].components(separatedBy: ",").map({Int($0)!}).splat()
            lightGrid.toggleLights(startX, startY, endX, endY, to: toggleTo)
        }
        
        return lightGrid.numberLit()
    }
    
    /*
     You just finish implementing your winning light pattern when you realize you mistranslated Santa's message from Ancient Nordic Elvish.
     
     The light grid you bought actually has individual brightness controls; each light can have a brightness of zero or more. The lights all start at zero.
     
     The phrase turn on actually means that you should increase the brightness of those lights by 1.
     
     The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.
     
     The phrase toggle actually means that you should increase the brightness of those lights by 2.
     
     What is the total brightness of all lights combined after following Santa's instructions?
     
     For example:
     
     turn on 0,0 through 0,0 would increase the total brightness by 1.
     toggle 0,0 through 999,999 would increase the total brightness by 2000000.

     */
    struct BrightableLights {
        var lights: [[Int]]
        init(numX: Int, numY: Int) {
            self.lights = Array(repeating: Array(repeating: 0, count: numX), count: numY)
        }
        
        func numberLit() -> Int {
            return lights.reduce(0, { $0 + $1.reduce(0, { $0 + $1 })})
        }
        
        private mutating func toggleLightsImp(_ startX: Int, _ startY: Int, _ endX: Int, _ endY: Int, _ delta: Int) {
            for x in startX...endX {
                for y in startY...endY {
                    lights[x][y] = max(lights[x][y] + delta, 0)
                }
            }
        }
        
        mutating func turnOnLights(_ fromX: Int, _ fromY: Int, _ toX: Int, _ toY: Int) {
            toggleLightsImp(fromX, fromY, toX, toY, 1)
        }
        mutating func turnOffLights(_ fromX: Int, _ fromY: Int, _ toX: Int, _ toY: Int) {
            toggleLightsImp(fromX, fromY, toX, toY, -1)
        }
        mutating func toggleLights(_ fromX: Int, _ fromY: Int, _ toX: Int, _ toY: Int) {
            toggleLightsImp(fromX, fromY, toX, toY, 2)
        }
    }
    
    func animateBrightLights(using pattern: String) -> Int {
        var lightGrid = BrightableLights(numX: 1000, numY: 1000)
        for step in pattern.components(separatedBy: "\n") {
            let stepComponents = step.components(separatedBy: " ")
            let i = stepComponents.first == "turn" ? 2 : 1
            
            let (startX, startY) = stepComponents[i].components(separatedBy: ",").map({Int($0)!}).splat()
            let (endX, endY) = stepComponents[i+2].components(separatedBy: ",").map({Int($0)!}).splat()
            
            if stepComponents.first == "toggle" { lightGrid.toggleLights(startX, startY, endX, endY) }
            else if stepComponents[1] == "on" { lightGrid.turnOnLights(startX, startY, endX, endY) }
            else if stepComponents[1] == "off" { lightGrid.turnOffLights(startX, startY, endX, endY) }
        }
        
        return lightGrid.numberLit()
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        print("After performing the animation \(animateLights(using: data)) lights are left on.")
        print("After performing the bright animation \(animateBrightLights(using: data)) is the total brightness.")
    }
    
    static func main() { Today().run() }
}
