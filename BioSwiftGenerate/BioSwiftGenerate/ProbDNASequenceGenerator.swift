//
//  ProbDNASequenceGenerator.swift
//  BioSwiftGenerate
//
//  Created by Alexandre Lopoukhine on 27/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore
import BioSwiftFastq

public class ProbDNASequenceGenerator {
    public static func generateSequence(ofLength length: Int) -> ProbDNASequence {
        var probNucleotideArray = [ProbNucleotide]()
        
        for i in 0..<length {
            let randomNumber = arc4random_uniform(4)
            
            let nucleotide: Nucleotide
            switch randomNumber {
            case 0:
                nucleotide = .A
            case 1:
                nucleotide = .C
            case 2:
                nucleotide = .G
            case 3:
                nucleotide = .T
            default:
                assertionFailure("Random number generator generated number out of 0..<4 range")
            }
            
            let errorProb = generateErrorProb()
            
            probNucleotideArray.append(ProbNucleotide.Known(nucleotide, errorProb))
        }
        
        assert(probNucleotideArray.count == length, "NucleotideArray length doesn't match up")
        
        return ProbDNASequence(probNucleotideArray)
    }
    
    // FASTQ sequences
    public static func generateSequenceLikeFASTQ(ofLength length: Int, fastqType: FASTQType) -> ProbDNASequence {
        var probNucleotideArray = [ProbNucleotide]()
        
        for i in 0..<length {
            let randomNumber = arc4random_uniform(4)
            
            let nucleotide: Nucleotide
            switch randomNumber {
            case 0:
                nucleotide = .A
            case 1:
                nucleotide = .C
            case 2:
                nucleotide = .G
            case 3:
                nucleotide = .T
            default:
                assertionFailure("Random number generator generated number out of 0..<4 range")
            }
            
            let errorProb = generateErrorProb()
            
            let score = fastqType.probToScore(errorProb)
            
            if 0 == score {
                probNucleotideArray.append(.Unknown)
            } else {
                probNucleotideArray.append(.Known(nucleotide, fastqType.scoreToProb(score)))
            }
        }
        
        assert(probNucleotideArray.count == length, "NucleotideArray length doesn't match up")
        
        return ProbDNASequence(probNucleotideArray)
    }
    
    public static func generateErrorProb() -> Double {
        return 0.5
    }
}
