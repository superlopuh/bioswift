//
//  DNASeq.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 31/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public struct DNASeq<N: NucleotideType>: CustomStringConvertible {
    public typealias Nuc = N
    
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
    
    public func getReverseAndComplement() -> DNASeq<N>  {
        return DNASeq<N>(nucleotideArray.reverse().map({$0.complement}))
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
    
    public var description: String {
        return nucleotideArray.map({$0.description}).joinWithSeparator("")
    }
}
