import Foundation

// Helper function, chooses max out of a variable number of parameters
func whichMax<C where C: Comparable> (toCompare: C...) -> Int {
    var maxIndex    = 0
    var previousMax = toCompare[0]
    
    for (index, comparee) in enumerate(toCompare) {
        if (comparee > previousMax) {
            maxIndex = index
            previousMax = comparee
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

func maxValueAndCoords<T where T: Comparable>(matrix: Matrix<T>) -> (value: T, coords: (row: Int, col: Int)) {
    func matrixNonEmpty(matrix: Matrix<T>) -> Bool {
        return matrix.rows != 0 && matrix.columns != 0
    }
    assert(matrixNonEmpty(matrix), "Cannot find max element of empty matrix")
    
    var maxCoords   = (0,0)
    var maxValue    = matrix[0,0]
    
    for row in 0..<matrix.rows {
        for column in 0..<matrix.columns {
            if matrix[row, column] >= maxValue {
                maxCoords = (row, column)
                maxValue  = matrix[row, column]
            }
        }
    }
    
    return (maxValue, maxCoords)
}

enum Pointer {
    case Up, Left, Diag
}

struct EditGraphCell: Equatable, Comparable {
    var score: Int
    var pointer: Pointer?
}

func ==(lhs: EditGraphCell, rhs: EditGraphCell) -> Bool {
    return lhs.score == rhs.score
}

func <(lhs: EditGraphCell, rhs: EditGraphCell) -> Bool {
    return lhs.score < rhs.score
}

let gapPenalty  = -1
let match       =  2
let misMatch    = -2

let stringA     = "AAACT"
let stringB     = "CTAAA"

func bestLocalAlignment(top: String, left: String) -> String {
    let leftArray = Array(left)
    let topArray = Array(top)
    var scoreAndPointerMatrix: Matrix<EditGraphCell> = Matrix<EditGraphCell>(rows: leftArray.count + 1, columns: topArray.count + 1, repeatedValue: EditGraphCell(score: 0, pointer: nil))
    
    
    scoreAndPointerMatrix
    
    // Main iteration
    for col in 1...topArray.count {
        for row in 1...leftArray.count {
            let skipTopScore    = scoreAndPointerMatrix[row, col-1].score + gapPenalty
            let skipLeftScore   = scoreAndPointerMatrix[row-1, col].score + gapPenalty
            let matchScore      = scoreAndPointerMatrix[row-1, col-1].score + (leftArray[row-1] == topArray[col-1] ? match : misMatch)
            switch whichMax(skipTopScore, skipLeftScore, matchScore, 0) {
            case 0:
                scoreAndPointerMatrix[row, col] = EditGraphCell(score: skipTopScore, pointer: Pointer.Left)
            case 1:
                scoreAndPointerMatrix[row, col] = EditGraphCell(score: skipLeftScore, pointer: Pointer.Up)
            case 2:
                scoreAndPointerMatrix[row, col] = EditGraphCell(score: matchScore, pointer: Pointer.Diag)
            default:
                // The value and pointer of the cell should stay as initialized
                continue
            }
        }
    }
    
    // Find maximum score in the matrix
    
    var (value, currentCoords) = maxValueAndCoords(scoreAndPointerMatrix)
    value
    
    // Trace back pointers
    var returnedTop: String = ""
    var returnedLeft:String = ""
    
    // Add missing end
    var endCoords = (row: leftArray.count, col: topArray.count)
    
    while endCoords.row - currentCoords.row != endCoords.col - currentCoords.col {
        if endCoords.row - currentCoords.row > endCoords.col - currentCoords.col {
            // bigger difference in rows than columns, move up
            returnedTop  = "-"                                  + "\t" + returnedTop
            returnedLeft = String(leftArray[endCoords.row - 1]) + "\t" + returnedLeft
            endCoords    = (endCoords.row - 1, endCoords.col)
        } else {
            // bigger difference in columns than rows, move left
            returnedTop  = String(topArray[endCoords.col - 1])  + "\t" + returnedTop
            returnedLeft = "-"                                  + "\t" + returnedLeft
            endCoords    = (endCoords.row, endCoords.col - 1)
        }
    }
    
    while endCoords.row > currentCoords.row && endCoords.col > currentCoords.col {
        returnedTop  = String(topArray[endCoords.col - 1])  + "\t" + returnedTop
        returnedLeft = String(leftArray[endCoords.row - 1]) + "\t" + returnedLeft
        endCoords    = (endCoords.row - 1, endCoords.col - 1)
        
    }

    
    while scoreAndPointerMatrix[currentCoords.row, currentCoords.col].pointer != nil {
        returnedTop + "\n" + returnedLeft
        currentCoords.row
        if let currentPointer = scoreAndPointerMatrix[currentCoords.row, currentCoords.col].pointer {
            currentPointer
            switch currentPointer {
            case .Up:
                returnedTop  = "-"                                        + "\t" + returnedTop
                returnedLeft = String(leftArray[currentCoords.row - 1])   + "\t" + returnedLeft
                currentCoords = (currentCoords.row - 1, currentCoords.col)
            case .Left:
                returnedTop  = String(topArray[currentCoords.col - 1])    + "\t" + returnedTop
                returnedLeft = "-"                                        + "\t" + returnedLeft
                currentCoords = (currentCoords.row, currentCoords.col - 1)
            case .Diag:
                returnedTop  = String(topArray[currentCoords.col - 1])    + "\t" + returnedTop
                returnedLeft = String(leftArray[currentCoords.row - 1])   + "\t" + returnedLeft
                currentCoords = (currentCoords.row - 1, currentCoords.col - 1)
            }
        } else {
            return "Error while traversing pointers"
        }
    }
    
    while 0 < currentCoords.row && 0 < currentCoords.col {
        returnedTop  = String(topArray[endCoords.col - 1])  + "\t" + returnedTop
        returnedLeft = String(leftArray[endCoords.row - 1]) + "\t" + returnedLeft
        endCoords    = (endCoords.row - 1, endCoords.col - 1)
    }
    
    returnedTop + "\n" + returnedLeft
    
    while 0 < currentCoords.row || 0 < currentCoords.col {
        if currentCoords.row > currentCoords.col {
            // Move up
            returnedTop  = "-"                                      + "\t" + returnedTop
            returnedLeft = String(leftArray[currentCoords.row - 1]) + "\t" + returnedLeft
            currentCoords    = (currentCoords.row - 1, currentCoords.col - 1)
        } else {
            // Move left
            returnedTop  = String(topArray[currentCoords.col - 1])  + "\t" + returnedTop
            returnedLeft = "-"                                      + "\t" + returnedLeft
            endCoords    = (currentCoords.row - 1, currentCoords.col - 1)
        }
    }
    
    return returnedTop + "\n" + returnedLeft
}


bestLocalAlignment(stringA, stringB)



