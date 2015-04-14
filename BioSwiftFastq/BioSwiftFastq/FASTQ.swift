//
//  FASTQ.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

public struct FASTQ {
    public let fastqType: FASTQType
    
    // Original Info
    public let fastqInfoString: String
    public let dnaString: String
    public let qualityString: String
    
    // Derived structure
    public let probDNASequence: DNASeq<ProbNucleotide>
    
    public init?(fastqInfoString: String, dnaString: String, qualityString: String, fastqType: FASTQType) {
        self.fastqType          = fastqType
        
        self.fastqInfoString    = fastqInfoString
        self.dnaString          = dnaString
        self.qualityString      = qualityString
        
        // Convert qualityString to probability array
        let optionalErrorProbArray = Array(qualityString).map() {
            return fastqType.charToProb($0)
        }
        
        if let errorProbArray = unwrap(optionalErrorProbArray) {
            var nucleotideArray = [ProbNucleotide]()
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
            
            self.probDNASequence = DNASeq<ProbNucleotide>(nucleotideArray)
            
        } else {
            println("QualityString did not unwrap successfully")
            return nil
        }
    }
    
    public var stringToWrite: String {
        var stringToWrite = "\(fastqInfoString)\n"
        stringToWrite    += "\(dnaString)\n"
        stringToWrite    += "+\n"
        stringToWrite    += "\(qualityString)\n"
        
        return stringToWrite
    }
}
