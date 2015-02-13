// Playground - noun: a place where people can play

import Foundation

// Helper function, chooses max out of a variable number of parameters
func whichMax<C where C: Comparable> (toCompare: C...) -> Int {
    var maxIndex    = 0
    var previousMax = toCompare[0]
    
    for (index, comparee) in enumerate(toCompare) {
        if (comparee > previousMax) {
            maxIndex = index
        }
    }
    
    return maxIndex
}

struct Matrix<T> {
    let rows: Int, columns: Int
    var grid: [T]
    init(rows: Int, columns: Int, repeatedValue: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: repeatedValue)
    }
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

enum Pointer {
    case Up, Left, Diag
}


let gapPenalty  = -1
let match       =  2
let misMatch    = -1

let stringA     = "ACGCTG"
let stringB     = "CATGT"

func globalAlignment(top: String, left: String) -> String {
    let leftArray = Array(left)
    let topArray = Array(top)
    var scoreAndPointerMatrix: Matrix<(Int, Pointer?)> = Matrix<(Int, Pointer?)>(rows: leftArray.count + 1, columns: topArray.count + 1, repeatedValue: (0, nil))
    
    // Initialise top row to decreasing scores 0, -1, -2, ...
    for index in 1...topArray.count {
        scoreAndPointerMatrix[0, index] = (-index, Pointer.Left)
    }
    
    // Initialise first column to decreasing scores 0, -1, -2, ...
    for index in 1...leftArray.count {
        scoreAndPointerMatrix[index, 0] = (-index, Pointer.Up)
    }
    
    scoreAndPointerMatrix
    
    // Main iteration
    for col in 1...topArray.count {
        for row in 1...leftArray.count {
            let skipTopScore    = scoreAndPointerMatrix[row, col-1].0 + gapPenalty
            let skipLeftScore   = scoreAndPointerMatrix[row-1, col].0 + gapPenalty
            let matchScore      = scoreAndPointerMatrix[row-1, col-1].0 + (leftArray[row-1] == topArray[col-1] ? match : misMatch)
            switch whichMax(skipTopScore, skipLeftScore, matchScore) {
            case 0:
                scoreAndPointerMatrix[row, col] = (skipTopScore, Pointer.Left)
            case 1:
                scoreAndPointerMatrix[row, col] = (skipLeftScore, Pointer.Up)
            case 2:
                scoreAndPointerMatrix[row, col] = (matchScore, Pointer.Diag)
            default:
                return "Error while comparing scores"
            }
        }
    }
    
    // Trace back pointers
    
    
    var returnedTop: String = ""
    var returnedLeft:String = ""
    
    var currentCoords = (row: leftArray.count, col: topArray.count)

    
    while scoreAndPointerMatrix[currentCoords.row, currentCoords.col].1 != nil {
        returnedTop + "\n" + returnedLeft
        currentCoords.row
        if let currentPointer = scoreAndPointerMatrix[currentCoords.row, currentCoords.col].1 {
            currentPointer
            switch currentPointer {
            case .Up:
                returnedLeft = String(leftArray[currentCoords.row - 1])   + "\t" + returnedLeft
                returnedTop  = "-"                                      + "\t" + returnedTop
                currentCoords = (currentCoords.row - 1, currentCoords.col)
            case .Left:
                returnedLeft = "-"                                      + "\t" + returnedLeft
                returnedTop  = String(topArray[currentCoords.col - 1])    + "\t" + returnedTop
                currentCoords = (currentCoords.row, currentCoords.col - 1)
            case .Diag:
                returnedLeft = String(leftArray[currentCoords.row - 1])   + "\t" + returnedLeft
                returnedTop  = String(topArray[currentCoords.col - 1])    + "\t" + returnedTop
                currentCoords = (currentCoords.row - 1, currentCoords.col - 1)
            }
        } else {
            return "Error while traversing pointers"
        }
    }
    
    return returnedTop + "\n" + returnedLeft
}


globalAlignment(stringA, stringB)



