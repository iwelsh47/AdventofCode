//
//  Day20.swift
//  Day20_2015
//
//  Created by Ivan Welsh on 15/01/24.
//

import Foundation

/*
 @nb.njit('List(int_)(int_)')
 def get_divisors(n):
 divisors = []
 if n == 1:
  divisors.append(1)
 elif n > 1:
  prime_factors = get_prime_divisors(n)
  divisors = [1]
  last_prime = 0
  factor = 0
  slice_len = 0
  # Find all the products that are divisors of n
  for prime in prime_factors:
   if last_prime != prime:
    slice_len = len(divisors)
    factor = prime
   else:
    factor *= prime
   for i in range(slice_len):
    divisors.append(divisors[i] * factor)
   last_prime = prime
  divisors.sort()
 return divisors
 */

extension Int {
    func primeDivisorsOf() -> [Int] {
        var n = self
        var divisors = [Int]()
        while n % 2 == 0 {
            divisors.append(2)
            n /= 2
        }
        while n % 3 == 0 {
            divisors.append(3)
            n /= 3
        }
        var i = 5
        while i * i <= n {
            while n % i == 0 {
                divisors.append(i)
                n /= i
            }
            while n % (i + 2) == 0 {
                divisors.append(i + 2)
                n /= (i + 2)
            }
            i += 6
        }
        if n > 1 {
            divisors.append(n)
        }
        return divisors
    }
    
    func divisorsOf() -> [Int] {
        if self <= 0 { return [] }
        else if self == 1 { return [1] }
        var divisors = [1, self]
        var maxPossible = Int(sqrt(Double(self)) + 1)
        var potentialDivisor = 2
        while potentialDivisor <= maxPossible {
            if self % potentialDivisor == 0 {
                divisors.append(contentsOf: [self / potentialDivisor, potentialDivisor])
                maxPossible = self / potentialDivisor
            }
            potentialDivisor += 1
        }
        return Array(Set(divisors)).sorted()
    }
}

@main final class Today: Day {
    init() { super.init(day: 20, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let target = 33100000
        var houseNumber = 10
        while houseNumber.divisorsOf().reduce(0, {$0 + 10 * $1}) < target {
            houseNumber += 1
        }
        print("It takes \(houseNumber) houses to exceed the targeted number of presents.")
        
        var visitedCounts = [1: 1]
        houseNumber = 1
        var divisors  = [1]
        while divisors.reduce(0, {
            if visitedCounts[$1]! <= 50 {
                return $0 + 11 * $1
            }
            return $0
        }) < target {
            houseNumber += 1
            divisors = houseNumber.divisorsOf()
            for n in divisors{ visitedCounts[n, default: 0] += 1 }
        }
        print("It takes \(houseNumber) houses to exceed the targeted number of presents when the elves are lazy.")
    }
    
    static func main() { Today().run() }
}
