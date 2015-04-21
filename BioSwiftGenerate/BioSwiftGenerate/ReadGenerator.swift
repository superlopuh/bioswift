//
//  ReadGenerator.swift
//  BioSwiftGenerate
//
//  Created by Alexandre Lopoukhine on 24/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

public class ReadGenerator {
    public static func generateReads<N: NucleotideType>(fromSequence initialSequence: DNASeq<N>, var readLength: Int) -> [DNASeq<N>] {
        let sequenceLength = initialSequence.length
        
        // Make sure that the reads aren't longer than initial sequence
        readLength = min(readLength, sequenceLength)
        
        var reads: [DNASeq<N>] = []
        
        for startIndex in 0...(sequenceLength - readLength) {
            reads.append(initialSequence[startIndex..<startIndex + readLength])
        }
        
        return reads
    }
}