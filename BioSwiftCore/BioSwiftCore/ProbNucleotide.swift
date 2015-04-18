//
//  ProbNucleotide.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 24/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public enum ProbNucleotide: NucleotideType, Hashable {
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
    
    public var hashValue: Int {
        switch self {
        case .Unknown:
            return 0
        case let .Known(nuc, errorProb):
            return nuc.hashValue * 3 + errorProb.hashValue
        }
    }
}

public func ==(lhs:ProbNucleotide, rhs: ProbNucleotide) -> Bool {
    switch (lhs, rhs) {
    case (.Unknown, .Unknown):
        return true
    case let (.Known(lhsNuc, lhsErrorProb), .Known(rhsNuc, rhsErrorProb)):
        return lhsNuc == rhsNuc && lhsErrorProb == rhsErrorProb
    default:
        return false
    }
}
