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
        let optionalErrorProbArray = Array(qualityString.characters).map() {
            return fastqType.charToProb($0)
        }
        
        if let errorProbArray = unwrap(optionalErrorProbArray) {
            var nucleotideArray = [ProbNucleotide]()
            for (index, character) in dnaString.characters.enumerate() {
                if let nucleotide = Nucleotide(char: character) {
                    let probNucleotide = ProbNucleotide.Known(nucleotide, errorProb: errorProbArray[index])
                    nucleotideArray.append(probNucleotide)
                } else if Character("N") == character {
                    // Unknown error probability
                    nucleotideArray.append(.Unknown)
                } else {
                    print("Could not initialise ProbNucleotide from \(character)")
                    return nil
                }
            }
            
            self.probDNASequence = DNASeq<ProbNucleotide>(nucleotideArray)
            
        } else {
            print("QualityString did not unwrap successfully")
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
    
    public func reverseAndComplement() -> FASTQ {
        var complementedDNAArray = [Character]()
        
        for character in dnaString.characters {
            switch character {
            case Character("A"):
                complementedDNAArray.append(Character("T"))
            case Character("T"):
                complementedDNAArray.append(Character("A"))
            case Character("C"):
                complementedDNAArray.append(Character("G"))
            case Character("G"):
                complementedDNAArray.append(Character("C"))
            case Character("N"):
                complementedDNAArray.append(Character("N"))
            default:
                assertionFailure("Found unknown character in DNA string in \n\(self.stringToWrite)")
            }
        }
        
        let newDNAString        = String(complementedDNAArray.reverse())
        
        let newQualityString    = String(qualityString.characters.reverse())
        return FASTQ(fastqInfoString: fastqInfoString, dnaString: newDNAString, qualityString: newQualityString, fastqType: fastqType)!
    }
}
