//
//  DNASequenceGenerator.swift
//  BioSwiftGenerate
//
//  Created by Alexandre Lopoukhine on 27/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

public class DNASequenceGenerator {
    public static func generateSequence(ofLength length: Int) -> DNASequence {
        var nucleotideArray = [Nucleotide]()
        
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
            
            nucleotideArray.append(nucleotide)
        }
        
        assert(nucleotideArray.count == length, "NucleotideArray length doesn't match up")
        
        return DNASequence(nucleotideArray)
    }
}
