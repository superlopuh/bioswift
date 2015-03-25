//
//  ProbDNASequence.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 25/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public struct ProbDNASequence: Printable {
    public var nucleotideArray: [ProbNucleotide]
    public var length: Int {
        return nucleotideArray.count
    }
    
    public init?(dnaString: String, errorProbArray: [Double]) {
        var nucleotideArray: [ProbNucleotide] = []
        let dnaStringLength = count(dnaString)
        
        if dnaStringLength != errorProbArray.count {
            // Lengths don't match up
            return nil
        }
        
        // Maybe check for errorProbs being in the correct range
        
        for (index, character) in enumerate(dnaString) {
            if let nucleotide = Nucleotide(char: character) {
                let probNucleotide = ProbNucleotide(nucleotide: nucleotide, errorProb: errorProbArray[index])
                nucleotideArray.append(probNucleotide)
            } else {
                return nil
            }
        }
        
        self.nucleotideArray = nucleotideArray
    }
    
    public init(nucleotideSlice: Slice<ProbNucleotide>) {
        var nucleotideArray: [ProbNucleotide] = []
        
        for probNucleotide in nucleotideSlice {
            nucleotideArray.append(probNucleotide)
        }
        
        self.nucleotideArray = nucleotideArray
    }
    
    public func subsequence(subRange: Range<Int>) -> ProbDNASequence {
        assert(subRange.startIndex >= 0 && subRange.endIndex <= length, "Subrange invalid")
        
        return ProbDNASequence(nucleotideSlice: nucleotideArray[subRange])
    }
    
    public subscript (index: Int) -> ProbNucleotide {
        return nucleotideArray[index]
    }
    
    public subscript (subRange: Range<Int>) -> ProbDNASequence {
        return subsequence(subRange)
    }
    
    public var description: String {
        var descString = "ProbDNASequence: "
        
        for probNucleotide in nucleotideArray {
            descString.append(probNucleotide.nucleotide.rawValue)
        }
        
        // Don't have probabilities in description
        
        return descString
    }
}

