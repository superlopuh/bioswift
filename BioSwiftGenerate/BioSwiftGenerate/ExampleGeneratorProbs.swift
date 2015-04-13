//
//  ExampleGeneratorProbs.swift
//  BioSwiftGenerate
//
//  Created by Alexandre Lopoukhine on 12/04/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

import BioSwiftCore
import BioSwiftFastq

func exampleGenerateErrorProb() -> Double {
    return 0.9
}

func exampleGenerateProbNucleotide(@noescape generateErrorProb: () -> Double) -> ProbNucleotide {
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
        nucleotide = .A
    }
    
    let errorProb = generateErrorProb()
    
    // Substitute another nucleotide as an error with uniform probability
    if randomDouble() < errorProb {
        // Generate an error nucleotide
        
        let errorNucleotide: Nucleotide
        switch arc4random_uniform(3) {
        case 0:
            errorNucleotide = .A
        case 1:
            errorNucleotide = .C
        case 2:
            errorNucleotide = .G
        default:
            assertionFailure("Random number generator generated number out of 0..<4 range")
            errorNucleotide = .A
        }
        
        return .Known(errorNucleotide == nucleotide ? .T : errorNucleotide, errorProb)
    } else {
        // Keep the same nucleotide
        
        return .Known(nucleotide, errorProb)
    }
}

func exampleGenerateProbNucleotdeLikeFASTQ(fastqType: FASTQType, @noescape generateErrorProb: () -> Double) -> ProbNucleotide {
    switch exampleGenerateProbNucleotide(generateErrorProb) {
    case .Unknown:
        return .Unknown
    case let .Known(nucleotide, errorProb):
        let score = fastqType.probToScore(errorProb)
        
        return .Known(nucleotide, fastqType.scoreToProb(score))
    }
}

func randomDouble() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX)
}
