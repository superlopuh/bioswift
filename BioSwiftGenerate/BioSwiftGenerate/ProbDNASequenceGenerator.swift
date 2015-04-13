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
    public static func generateSequence(ofLength length: Int, @noescape errorProbGenerator: () -> ProbNucleotide) -> ProbDNASequence {
        var probNucleotideArray = [ProbNucleotide]()
        
        for i in 0..<length {
            probNucleotideArray.append(errorProbGenerator())
        }
        
        assert(probNucleotideArray.count == length, "NucleotideArray length doesn't match up")
        
        return ProbDNASequence(probNucleotideArray)
    }
}
