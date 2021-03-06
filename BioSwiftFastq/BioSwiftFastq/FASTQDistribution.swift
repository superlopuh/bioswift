//
//  FASTQDistribution.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 19/04/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

private let aDistKey = "aDistribution"
private let tDistKey = "tDistribution"
private let gDistKey = "gDistribution"
private let cDistKey = "cDistribution"
private let nDistKey = "nDistribution"

public class FASTQDistribution {
    public let aDistribution: [Character:Int]
    public let tDistribution: [Character:Int]
    public let gDistribution: [Character:Int]
    public let cDistribution: [Character:Int]
    public let nDistribution: [Character:Int]
    
    public init(aDistribution: [Character:Int], tDistribution: [Character:Int], gDistribution: [Character:Int], cDistribution: [Character:Int], nDistribution: [Character:Int]) {
        self.aDistribution = aDistribution
        self.tDistribution = tDistribution
        self.gDistribution = gDistribution
        self.cDistribution = cDistribution
        self.nDistribution = nDistribution
    }
    
    public init?(fileAddress: NSURL) {
        guard let filePath = fileAddress.path where NSFileManager.defaultManager().fileExistsAtPath(filePath),
            let myDict = NSDictionary(contentsOfURL: fileAddress) else {
                self.aDistribution = [:]
                self.tDistribution = [:]
                self.gDistribution = [:]
                self.cDistribution = [:]
                self.nDistribution = [:]
                return nil
        }
        if let aDist = myDict[aDistKey] as? [String:Int],
        let tDist = myDict[tDistKey] as? [String:Int],
        let gDist = myDict[gDistKey] as? [String:Int],
        let cDist = myDict[cDistKey] as? [String:Int],
        let nDist = myDict[nDistKey] as? [String:Int] {
            
            self.aDistribution = aDist.map({(Character($0), $1)})
            self.tDistribution = tDist.map({(Character($0), $1)})
            self.gDistribution = gDist.map({(Character($0), $1)})
            self.cDistribution = cDist.map({(Character($0), $1)})
            self.nDistribution = nDist.map({(Character($0), $1)})
            
        } else {
            self.aDistribution = [:]
            self.tDistribution = [:]
            self.gDistribution = [:]
            self.cDistribution = [:]
            self.nDistribution = [:]
            return nil
        }
    }
    
    public func writeToPlist(atAddress fileAddress: NSURL) throws {
        if let filePath = fileAddress.path {
            let dict: NSMutableDictionary = [:]
            
            // Character is not a serialisable type, have to map to String
            let myADist = aDistribution.map() {(String($0), $1)}
            let myTDist = tDistribution.map() {(String($0), $1)}
            let myGDist = gDistribution.map() {(String($0), $1)}
            let myCDist = cDistribution.map() {(String($0), $1)}
            let myNDist = nDistribution.map() {(String($0), $1)}
            
            // Set values to the dictionary being written
            dict.setObject(myADist, forKey: aDistKey)
            dict.setObject(myTDist, forKey: tDistKey)
            dict.setObject(myGDist, forKey: gDistKey)
            dict.setObject(myCDist, forKey: cDistKey)
            dict.setObject(myNDist, forKey: nDistKey)
            
            // If folder doesn't exist, create one
            if let folderPath = fileAddress.URLByDeletingLastPathComponent?.path {
                // check if element is a directory
                var isDirectory: ObjCBool = ObjCBool(false)
                // Mutates isDirectory pointer
                NSFileManager.defaultManager().fileExistsAtPath(folderPath, isDirectory: &isDirectory)
                
                if !isDirectory {
                    try NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: false, attributes: nil)
                }
            }
            
            dict.writeToFile(filePath, atomically: false)
            
            // Test that everything was written correctly
            let resultDict = NSMutableDictionary(contentsOfFile: filePath)
            print("Saved distribution:\n\(resultDict)")
        }
    }
    
    
    // Counts
    public lazy var aCount: Int = {
        return Array(self.aDistribution).reduce(0, combine: {$0 + $1.1})
    }()
    
    public lazy var tCount: Int = {
        return Array(self.tDistribution).reduce(0, combine: {$0 + $1.1})
    }()
    
    public lazy var gCount: Int = {
        return Array(self.gDistribution).reduce(0, combine: {$0 + $1.1})
    }()
    
    public lazy var cCount: Int = {
        return Array(self.cDistribution).reduce(0, combine: {$0 + $1.1})
    }()
    
    public lazy var nCount: Int = {
        return Array(self.nDistribution).reduce(0, combine: {$0 + $1.1})
    }()
    
    public lazy var atCount: Int = {self.aCount + self.tCount}()
    
    public lazy var gcCount: Int = {self.gCount + self.cCount}()
    
    public lazy var totalCount: Int = {self.atCount + self.gcCount}()
    
    
    // Probabilities
    public lazy var aProb: Double = {
        return Double(self.aCount)/Double(self.totalCount)
    }()
    public lazy var tProb: Double = {
        return Double(self.tCount)/Double(self.totalCount)
    }()
    public lazy var gProb: Double = {
        return Double(self.gCount)/Double(self.totalCount)
    }()
    public lazy var cProb: Double = {
        return Double(self.cCount)/Double(self.totalCount)
    }()
    public lazy var nProb: Double = {
        return Double(self.nCount)/Double(self.totalCount)
    }()
    
    
    // For getting probability of a certain ProbNucleotide being generated
    public func getProbabilityCalculatorForFASTQType(fastqType: FASTQType) -> ProbNucleotide -> Double {
        var probDictionary = [ProbNucleotide:Double]()
        
        let totalCount = Double(self.totalCount)
        
        for (character, count) in aDistribution {
            if let errorProb = fastqType.charToProb(character) {
                probDictionary[.Known(.A, errorProb: errorProb)] = Double(count)/totalCount
            }
        }
        
        for (character, count) in tDistribution {
            if let errorProb = fastqType.charToProb(character) {
                probDictionary[.Known(.T, errorProb: errorProb)] = Double(count)/totalCount
            }
        }
        
        for (character, count) in gDistribution {
            if let errorProb = fastqType.charToProb(character) {
                probDictionary[.Known(.G, errorProb: errorProb)] = Double(count)/totalCount
            }
        }
        
        for (character, count) in cDistribution {
            if let errorProb = fastqType.charToProb(character) {
                probDictionary[.Known(.C, errorProb: errorProb)] = Double(count)/totalCount
            }
        }
        
        probDictionary[.Unknown] = Double(nCount)/totalCount
        
        return {(probNucleotide: ProbNucleotide) -> Double in
            if let prob = probDictionary[probNucleotide] {
                return prob
            } else {
                print("Unexpectedly found nil in distribution, maybe the file isn't the right one")
                return 0.0
            }
        }
    }
}

extension FASTQDistribution: CustomStringConvertible {
    public var description: String {
        var description = "FASTQ distribution:\n"
        
        func charDictDescription(charDict: [Character:Int]) -> String {
            let sortedPairArray = Array(charDict).sort() {(lhsPair: (char: Character, Int), rhsPair: (char: Character, Int)) -> Bool in
                return lhsPair.char.scalarValue < rhsPair.char.scalarValue
            }
            
            return sortedPairArray.reduce("") {(previous: String, nextPair: (char: Character, count: Int)) -> String in
                return previous + "\(nextPair.char) - \(nextPair.count)\n"
            }
        }
        
        description +=   "A:\n" + charDictDescription(aDistribution)
        description += "\nT:\n" + charDictDescription(tDistribution)
        description += "\nG:\n" + charDictDescription(gDistribution)
        description += "\nC:\n" + charDictDescription(cDistribution)
        description += "\nN:\n" + charDictDescription(nDistribution)
        
        return description
    }
}

extension Character {
    var scalarValue: Int {
        let unicodeScalarView = String(self).unicodeScalars
        let firstUnicodeScalar: UnicodeScalar = unicodeScalarView[unicodeScalarView.startIndex]
        
        return Int(firstUnicodeScalar.value)
    }
}
