import Foundation
import CryptoKit

@main final class Today: Day {
    init() { super.init(day: 4, year: 2015) }
    /*
     Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all
     the economically forward-thinking little girls and boys.
     
     To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five
     zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below)
     followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest
     positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.
     
     For example:
     
     If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043
     starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
     If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash
     starting with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like
     000006136ef....
     */
    
    func findLowestIntegerMD5(of data: String, leadingZeros: Int, initialValue: Int = 0) -> Int {
        let targetLeading = String(format: "MD5 digest: %0\(leadingZeros)d", 0)
        var trailingValue = initialValue
        
        while !Insecure.MD5.hash(data: "\(data)\(trailingValue)"
            .data(using: .utf8)!)
            .description
            .starts(with: targetLeading) {
            trailingValue += 1
        }
        return trailingValue
    }
    
    /*
     Now find one that starts with six zeroes.
     */
    override func run() {
        print("Running \(year), day \(day)")
        let fiveLeadingZeros = findLowestIntegerMD5(of: data, leadingZeros: 5)
        print("First value with 5 leading zeroes is \(fiveLeadingZeros)")
        let sixLeadingZeros = findLowestIntegerMD5(of: data, leadingZeros: 6, initialValue: fiveLeadingZeros)
        print("First value with 6 leading zeroes is \(sixLeadingZeros)")
    }
    
    static func main() { Today().run() }
}
