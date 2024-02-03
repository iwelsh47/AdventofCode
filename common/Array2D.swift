//
//  Array2D.swift
//  Day17_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

struct Array2D<T> where T: Equatable {
    let columns: Int
    let rows: Int
    
    var data: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        data = Array<T?>(repeating: nil, count: columns * rows)
    }
    
    init(columns: Int, rows: Int, fill: T) {
        self.columns = columns
        self.rows = rows
        data = Array<T?>(repeating: fill, count: columns * rows)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get { return data[row * columns + column] }
        set { data[row * columns + column] = newValue }
    }
    
    func getXY(from idx: Int) -> (x: Int, y: Int) {
        let (y, x) = idx.quotientAndRemainder(dividingBy: columns)
        return (x, y)
    }
    
    func getIdx(from x: Int, and y: Int) -> Int {
        return y * columns + x
    }
    
    func firstIndex(of value: T?) -> Int? {
        return data.firstIndex(where: { $0 == value })
    }
}
