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
            println("Lengths don't match up for ProbDNASequence")
            return nil
        }
        
        // Maybe check for errorProbs being in the correct range
        
        for (index, character) in enumerate(dnaString) {
            if let nucleotide = Nucleotide(char: character) {
                let probNucleotide = ProbNucleotide.Known(nucleotide, errorProbArray[index])
                nucleotideArray.append(probNucleotide)
            } else if Character("N") == character {
                // Unknown error probability
                nucleotideArray.append(.Unknown)
            } else {
                println("Could not initialise ProbNucleotide from \(character)")
                return nil
            }
        }
        
        assert(nucleotideArray.count == dnaStringLength, "DNAString length is not equal to ProbNucleotide array")
        
        self.nucleotideArray = nucleotideArray
    }
    
    public init?(dnaSequence: DNASequence, errorProbArray: [Double]) {
        if dnaSequence.length != errorProbArray.count {
            println("Lengths don't match up for ProbDNASequence")
            return nil
        }
        // Maybe check for errorProbs being in the correct range
        
        var probNucleotideArray: [ProbNucleotide] = []
        
        for (index, nucleotide) in enumerate(dnaSequence.nucleotideArray) {
            let probNucleotide = ProbNucleotide.Known(nucleotide, errorProbArray[index])
            probNucleotideArray.append(probNucleotide)
        }
        
        assert(probNucleotideArray.count == dnaSequence.length, "DNAString length is not equal to ProbNucleotide array")
        
        self.nucleotideArray = probNucleotideArray
    }
    
    public init<S: SequenceType where S.Generator.Element == ProbNucleotide>(_ nucleotideSequence: S) {
        var nucleotideArray: [ProbNucleotide] = []
        
        for probNucleotide in nucleotideSequence {
            nucleotideArray.append(probNucleotide)
        }
        
        self.nucleotideArray = nucleotideArray
    }
    
    public func subsequence(subRange: Range<Int>) -> ProbDNASequence {
        assert(subRange.startIndex >= 0 && subRange.endIndex <= length, "Subrange invalid")
        
        return ProbDNASequence(nucleotideArray[subRange])
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
            switch probNucleotide {
            case .Known(let nucleotide, _):
                descString.append(nucleotide.rawValue)
            case .Unknown:
                descString += "N"
            }
        }
        
        // Don't have probabilities in description
        
        return descString
    }
}

