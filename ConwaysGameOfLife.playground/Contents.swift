//
// Conway's Game of Life
// Swift Playground
//
// Created by Juan Gestal on 09.03.2019
// juan@gestal.es - www.gestal.es
//

struct World {
    
    let rows: Int
    let cols: Int
    let isToroidal: Bool
    
    var matrix: [Bool]
    
    init(rows: Int, cols: Int, isToroidal: Bool) {
        self.rows = rows
        self.cols = cols
        self.isToroidal = isToroidal
        matrix = Array(repeating: false, count: rows * cols)
    }
    
    private func aliveNeighbours(_ row: Int, _ col: Int) -> Int {
        
        var aliveCounter = 0;
        
        [(-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)].forEach {
            aliveCounter += f(row + $0.0,col + $0.1) ? 1 : 0;
        }
    
        return aliveCounter;
    }
    
    fileprivate func f(_ row: Int, _ col: Int) -> Bool {
        
        var r = row;
        var c = col;
                
        if (isToroidal) {
            r = matrixIndexToroidalTransformation(index: r, maxIndex: rows)
            c = matrixIndexToroidalTransformation(index: c, maxIndex: cols)
        }
        
        return c < 0 || r < 0 || c >= cols || r >= rows ? false : self[r,c]
    }
    
    fileprivate func matrixIndexToroidalTransformation(index: Int, maxIndex: Int) -> Int {
        return index >= maxIndex ? index - maxIndex : index < 0 ? index + maxIndex : index;
    }
    
    subscript(row: Int, col: Int) -> Bool {
        get {
            return matrix[(row * cols) + col]
        }
        set {
            matrix[(row * cols) + col] = newValue
        }
    }
    
    func show () {
        for r in 0..<rows {
            for c in 0..<cols {
                print(self[r,c] ? "1 " : "0 ", terminator: "")
            }
            print("")
        }
        print("")
    }
    
    func nextGeneration () -> World {
    
        var newWorld = World(rows: rows, cols: cols, isToroidal: isToroidal)
        
        for r in 0..<rows {
            for c in 0..<cols {
                
                // GAME RULES:
                // 1. Any live cell with two or three neighbors survives.
                // 2. Any dead cell with three live neighbors becomes a live cell.
                // 3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.
                
                let neighbors = aliveNeighbours(r,c)
                
                if (self[r,c] && (neighbors == 2 || neighbors == 3)) {
                    newWorld[r,c] = true
                }
                else if (!self[r,c] && neighbors == 3) {
                    newWorld[r,c] = true
                }
            }
        }
        
        return newWorld
    }
}

// Example:
var w = World(rows: 10, cols: 10, isToroidal: true)

w[2,0] = true
w[3,0] = true
w[4,0] = true

w.show()

w = w.nextGeneration()
w.show()

w = w.nextGeneration()
w.show()

w = w.nextGeneration()
w.show()
