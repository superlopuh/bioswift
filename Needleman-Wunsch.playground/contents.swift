//: # Needleman-Wunsch
//:
//: Time complexity: O(nm)
//:
//: Space complexity: O(nm)
//:
//: ----
//:
//: This algorithm is used to assess the similarity of two strings. It tries to align the entirety of the two strings, as opposed to aligning just the best-fitting substrings.
//:
//: It works by filling the edit graph from the top left to the bottom right, and tracing the path back. Each cell stores the score of the alignment of the two substrings so far, as well as a pointer to the cell of a best alignment of the prefix.
import Foundation

// Helper function, chooses max out of a variable number of parameters
func whichMax<C where C: Comparable> (toCompare: C...) -> Int? {
    guard !toCompare.isEmpty else {return nil}
    
    return toCompare.enumerate().maxElement({
        $0.1 < $1.1
    })!.0
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

let seqA     = Array("ACGCTG".characters)
let seqB     = Array("CATGT".characters)

func globalAlignment<N: Equatable, NN: CollectionType where NN.Generator.Element == N, NN.Index == Int>(top: NN, _ left: NN) -> String {
    var scoreAndPointerMatrix: Matrix<(Int, Pointer?)> = Matrix<(Int, Pointer?)>(rows: left.count + 1, columns: top.count + 1, repeatedValue: (0, nil))
    
    // Initialise top row to decreasing scores 0, -1, -2, ...
    for index in 1...top.count {
        scoreAndPointerMatrix[0, index] = (-index, Pointer.Left)
    }
    
    // Initialise first column to decreasing scores 0, -1, -2, ...
    for index in 1...left.count {
        scoreAndPointerMatrix[index, 0] = (-index, Pointer.Up)
    }
    
    scoreAndPointerMatrix
    
    // Main iteration
    for col in 1...top.count {
        for row in 1...left.count {
            let skipTopScore    = scoreAndPointerMatrix[row, col-1].0 + gapPenalty
            let skipLeftScore   = scoreAndPointerMatrix[row-1, col].0 + gapPenalty
            let matchScore      = scoreAndPointerMatrix[row-1, col-1].0 + (left[row-1] == top[col-1] ? match : misMatch)
            switch whichMax(skipTopScore, skipLeftScore, matchScore)! {
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
    
    var currentCoords = (row: left.count, col: top.count)
    
    
    while scoreAndPointerMatrix[currentCoords.row, currentCoords.col].1 != nil {
        returnedTop + "\n" + returnedLeft
        currentCoords.row
        if let currentPointer = scoreAndPointerMatrix[currentCoords.row, currentCoords.col].1 {
            currentPointer
            switch currentPointer {
            case .Up:
                returnedLeft = String(left[currentCoords.row - 1])   + "\t" + returnedLeft
                returnedTop  = "-"                                      + "\t" + returnedTop
                currentCoords = (currentCoords.row - 1, currentCoords.col)
            case .Left:
                returnedLeft = "-"                                      + "\t" + returnedLeft
                returnedTop  = String(top[currentCoords.col - 1])    + "\t" + returnedTop
                currentCoords = (currentCoords.row, currentCoords.col - 1)
            case .Diag:
                returnedLeft = String(left[currentCoords.row - 1])   + "\t" + returnedLeft
                returnedTop  = String(top[currentCoords.col - 1])    + "\t" + returnedTop
                currentCoords = (currentCoords.row - 1, currentCoords.col - 1)
            }
        } else {
            return "Error while traversing pointers"
        }
    }
    
    return returnedTop + "\n" + returnedLeft
}


globalAlignment(seqA, seqB)
