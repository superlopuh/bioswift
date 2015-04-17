//
//  ProbNucleotide.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 24/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public enum ProbNucleotide: NucleotideType {
    case Unknown
    case Known(Nucleotide, Double)
    
    public func probOfMatchWithNucleotide(nucleotide: Nucleotide) -> Double {
        switch self {
        case .Unknown:
            return 0.25
        case let .Known(nuc, errorProb):
            if nuc == nucleotide {
                return 1.0 - errorProb
            } else {
                return errorProb / 3.0
            }
        }
    }
    
    public var description: String {
        switch self {
        case .Unknown:
            return "N"
        case .Known(let nucleotide, _):
            return nucleotide.description
        }
    }
}
