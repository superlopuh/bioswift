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
    
    public func charToProb(character: Character) -> Double? {
        // Mess about with Swift strings to get ascii
        let unicodeScalarView = String(character).unicodeScalars
        let firstUnicodeScalar: UnicodeScalar = unicodeScalarView[unicodeScalarView.startIndex]
        
        if !firstUnicodeScalar.isASCII() {
            // Check that firstUnicodeScalar is an ascii character
            return nil
        }
        
        let scalarValue = firstUnicodeScalar.value
        
        let adjustedQ = Int(scalarValue)
        
        let qualityScore = Double(adjustedQ - getPhred())
        
        let errorProbability = pow(10.0, -qualityScore/10.0)
        
        switch self{
        case .Sanger:
            return errorProbability
        case .Illumina18:
            return errorProbability
        case .Illumina15:
            println("Illumina 1.5 FASTQ not yet implemented")
            return nil
        }
    }
    
    public func probToChar(errorProbability: Double) -> Character? {
        let qualityScore = -10 * log10(errorProbability)
        
        let adjustedQ = Int(qualityScore) + getPhred()
        
        return Character(UnicodeScalar(adjustedQ))
    }
}
