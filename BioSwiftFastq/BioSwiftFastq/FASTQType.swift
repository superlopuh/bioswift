//
//  FASTQType.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

// All info from here:
// http://en.wikipedia.org/wiki/FASTQ_format

public enum FASTQType {
    case Illumina18, Illumina15, Sanger
    
    public func getPhred() -> Int {
        switch self {
        case .Sanger:
            return 33
        case .Illumina18:
            return 33
        case .Illumina15:
            return 64
        }
    }
    
    public func scoreToProb(qualityScore: Int) -> Double {
        return pow(10.0, -Double(qualityScore)/10.0)
    }
    
    public func probToScore(errorProbability: Double) -> Int {
        return Int(-10.0 * log10(errorProbability))
    }
    
    public func charToScore(character: Character) -> Int? {
        // Mess about with Swift strings to get ascii
        let unicodeScalarView = String(character).unicodeScalars
        let firstUnicodeScalar: UnicodeScalar = unicodeScalarView[unicodeScalarView.startIndex]
        
        if !firstUnicodeScalar.isASCII() {
            // Check that firstUnicodeScalar is an ascii character
            return nil
        }
        
        let scalarValue = firstUnicodeScalar.value
        
        let adjustedQ = Int(scalarValue)
        
        let qualityScore = adjustedQ - getPhred()
        
        switch self{
        case .Sanger:
            return qualityScore
        case .Illumina18:
            return qualityScore
        case .Illumina15:
            return qualityScore
        }
    }
    
    public func charToProb(character: Character) -> Double? {
        if let score = charToScore(character) {
            return scoreToProb(score)
        } else {
            return nil
        }
    }
    
    public func probToChar(errorProbability: Double) -> Character? {
        let adjustedQ = probToScore(errorProbability) + getPhred()
        
        return Character(UnicodeScalar(adjustedQ))
    }
}
