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
    
    public func probabilityMatch(otherNucleotide: Nucleotide) -> Double {
        switch self{
        case .Unknown:
            return 0.25
        case let .Known(nucleotide, errorProb):
            if nucleotide == otherNucleotide {
                return 1.0 - errorProb
            } else {
                return errorProb / 3.0
            }
        }
    }
}
