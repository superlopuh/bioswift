//
//  DNASequence.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public struct DNASequence: Equatable, Printable, DNASequenceType {
    public typealias N = Nucleotide
    
    public var nucleotideArray: [Nucleotide]
    public var length: Int {
        return nucleotideArray.count
    }
    
    public init?(dnaString: String) {
        var nucleotideArray: [Nucleotide] = []
        
        for character in dnaString {
            if let nucleotide = Nucleotide(char: character) {
                nucleotideArray.append(nucleotide)
            } else {
                return nil
            }
        }
        
        self.nucleotideArray = nucleotideArray
    }
    
    public init<S: SequenceType where S.Generator.Element == Nucleotide>(_ nucleotideSequence: S) {
        var nucleotideArray: [Nucleotide] = []
        var initialString = ""
        
        for nucleotide in nucleotideSequence {
            nucleotideArray.append(nucleotide)
            initialString.append(nucleotide.rawValue)
        }
        
        self.nucleotideArray = nucleotideArray
    }
    
    public func subsequence(subRange: Range<Int>) -> DNASequence {
        assert(subRange.startIndex >= 0 && subRange.endIndex <= length, "Subrange invalid")
        
        return DNASequence(nucleotideArray[subRange])
    }
    
    public subscript (index: Int) -> Nucleotide {
        return nucleotideArray[index]
    }
    
    public subscript (subRange: Range<Int>) -> DNASequence {
        return subsequence(subRange)
    }
    
    public var description: String {
        var descString = ""
        
        for nucleotide in nucleotideArray {
            descString.append(nucleotide.rawValue)
        }
        
        return descString
    }
}

public func ==(lhs: DNASequence, rhs: DNASequence) -> Bool {
    if lhs.length == rhs.length {
        for index in 0..<lhs.length {
            if lhs.nucleotideArray[index] != rhs.nucleotideArray[index] {
                return false
            }
        }
        return true
    } else {
        return false
    }
}
