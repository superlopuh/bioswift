//
//  DNASeq.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 31/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public struct DNASeq<N: NucleotideType> {
    public var nucleotideArray: [N]
    public var length: Int {
        return nucleotideArray.count
    }
    
    public init<S: SequenceType where S.Generator.Element == N>(_ nucleotideSequence: S) {
        var nucleotideArray: [N] = []
        
        for nucleotide in nucleotideSequence {
            nucleotideArray.append(nucleotide)
        }
        
        self.nucleotideArray = nucleotideArray
    }
    
    public func subsequence(subRange: Range<Int>) -> DNASeq<N> {
        assert(subRange.startIndex >= 0 && subRange.endIndex <= length, "Subrange invalid")
        
        return DNASeq<N>(nucleotideArray[subRange])
    }
    
    public subscript (index: Int) -> N {
        return nucleotideArray[index]
    }
    
    public subscript (subRange: Range<Int>) -> DNASeq<N> {
        return subsequence(subRange)
    }
}
