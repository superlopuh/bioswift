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
    public static func generateReads(fromSequence initialSequence: DNASequence, readLength: Int) -> [DNASequence] {
        let sequenceLength = initialSequence.length
        assert(readLength <= sequenceLength, "Can't generate reads longer than original sequence")
        
        var reads: [DNASequence] = []
        
        for startIndex in 0...(sequenceLength - readLength) {
            reads.append(initialSequence[startIndex..<startIndex + readLength])
        }
        
        return reads
    }
}