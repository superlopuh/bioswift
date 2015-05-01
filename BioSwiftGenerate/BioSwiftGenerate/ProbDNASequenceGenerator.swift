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
    public static func generateSequence(ofLength length: Int, @noescape probNucGenerator: () -> ProbNucleotide) -> DNASeq<ProbNucleotide> {
        var probNucleotideArray = [ProbNucleotide]()
        
        for i in 0..<length {
            probNucleotideArray.append(probNucGenerator())
        }
        
        assert(probNucleotideArray.count == length, "NucleotideArray length doesn't match up")
        
        return DNASeq<ProbNucleotide>(probNucleotideArray)
    }
    
    public static func generateSequence(ofLength length: Int, @noescape probNucGenerator: Nucleotide -> ProbNucleotide) -> DNASeq<ProbNucleotide> {
        let nucleotideArray = DNASequenceGenerator.generateSequence(ofLength: length).nucleotideArray
        
        var probNucleotideArray = [ProbNucleotide]()
        
        for i in 0..<length {
            probNucleotideArray.append(probNucGenerator(nucleotideArray[i]))
        }
        
        assert(probNucleotideArray.count == length, "NucleotideArray length doesn't match up")
        
        return DNASeq<ProbNucleotide>(probNucleotideArray)
    }
    
    public static func generateSequence(fromDNASequence dnaSequence: DNASeq<Nucleotide>, @noescape probNucGenerator: Nucleotide -> ProbNucleotide) -> DNASeq<ProbNucleotide> {
        let nucleotideArray = dnaSequence.nucleotideArray
        
        var probNucleotideArray = [ProbNucleotide]()
        
        for i in 0..<dnaSequence.length {
            probNucleotideArray.append(probNucGenerator(nucleotideArray[i]))
        }
        
        return DNASeq<ProbNucleotide>(probNucleotideArray)
    }
}
