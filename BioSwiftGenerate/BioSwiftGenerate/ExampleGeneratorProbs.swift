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
    
    return .Known(nucleotide, errorProb)
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
