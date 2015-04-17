//
//  Nucleotide.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public enum Nucleotide: Character, NucleotideType {
    case A = "A"
    case C = "C"
    case G = "G"
    case T = "T"
    
    public func probOfMatchWithNucleotide(nucleotide: Nucleotide) -> Double {
        return nucleotide == self ? 1.0 : 0.0
    }
    
    public init?(char: Character) {
        switch char {
        case Character("A"):
            self = .A
        case Character("C"):
            self = .C
        case Character("G"):
            self = .G
        case Character("T"):
            self = .T
        default:
            return nil
        }
    }
    
    public var description: String {
        return String(self.rawValue)
    }
}
