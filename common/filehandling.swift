//
//  filehandling.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

func loadData(from filename: String, for year: Int) -> String {
    let filePath = "data/\(year)/\(filename)"
    do {
        let contents = try String(contentsOfFile: filePath).trimmed()
        return contents
    } catch {
        print("Could not load data from file \(filePath). \(error.localizedDescription).")
        exit(EXIT_FAILURE)
    }
}
