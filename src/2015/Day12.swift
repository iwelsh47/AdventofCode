//
//  Day12.swift
//  Day12_2015
//
//  Created by Ivan Welsh on 13/01/24.
//

import Foundation

func performConversion(of json: Any) -> Array<Any>? {
    guard var array = json as? Array<Any> else { return nil }
    for index in 0 ..< array.count {
        if let item: Dictionary<String, Any> = performConversion(of: array[index]) {
            array[index] = item
        } else if let item: Array<Any> = performConversion(of: array[index]) {
            array[index] = item
        } else if let item: Int = performConversion(of: array[index]) {
            array[index] = item
        } else if let item: String = performConversion(of: array[index]) {
            array[index] = item
        }
    }
    return array
}

func performConversion(of json: Any) -> Int? { return json as? Int }

func performConversion(of json: Any) -> String? { return json as? String }

func performConversion(of json: Any) -> Dictionary<String, Any>? {
    guard var dictionary = json as? Dictionary<String, Any> else { return nil }
    for key in dictionary.keys {
        if let value: Dictionary<String, Any> = performConversion(of: dictionary[key]!) {
            dictionary[key] = value
        } else if let value: Array<Any> = performConversion(of: dictionary[key]!) {
            dictionary[key] = value
        } else if let value: Int = performConversion(of: dictionary[key]!) {
            dictionary[key] = value
        } else if let value: String = performConversion(of: dictionary[key]!) {
            dictionary[key] = value
        }
    }
    return dictionary
}

func sumAllIntegers(nestedIn json: Int) -> Int { return json }
func sumAllIntegers(nestedIn json: String) -> Int { return 0 }
func sumAllIntegers(nestedIn json: Array<Any>, skip: String? = nil) -> Int {
    var arraySum = 0
    for item in json {
        if let value: Dictionary<String, Any> = performConversion(of: item) {
            arraySum += sumAllIntegers(nestedIn: value, skip: skip)
        } else if let value: Array<Any> = performConversion(of: item) {
            arraySum += sumAllIntegers(nestedIn: value, skip: skip)
        } else if let value: Int = performConversion(of: item) {
            arraySum += value
        } // No need for string
    }
    return arraySum
}

func sumAllIntegers(nestedIn json: Dictionary<String, Any>, skip: String? = nil) -> Int {
    var dictionarySum = 0
    for item in json {
        if let value: Dictionary<String, Any> = performConversion(of: item.value) {
            dictionarySum += sumAllIntegers(nestedIn: value, skip: skip)
        } else if let value: Array<Any> = performConversion(of: item.value) {
            dictionarySum += sumAllIntegers(nestedIn: value, skip: skip)
        } else if let value: Int = performConversion(of: item.value) {
            dictionarySum += value
        } else if let value: String = performConversion(of: item.value) {
            if let skip, value == skip { return 0 }
        }
    }
    return dictionarySum
}

@main final class Today: Day {
    init() { super.init(day: 12, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let json: Any
        do {
            json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: .mutableLeaves)
        } catch {
            return
        }
        
        guard let converted: Dictionary<String, Any> = performConversion(of: json) else { return }
        print("Sum of all integers is \(sumAllIntegers(nestedIn: converted))")
        print("Sum of all integers skipping red objects is \(sumAllIntegers(nestedIn: converted, skip: "red"))")
    }
    
    static func main() { Today().run() }
}
