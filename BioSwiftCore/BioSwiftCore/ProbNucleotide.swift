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
    
    public var description: String {
        switch self {
        case .Unknown:
            return "N"
        case .Known(let nucleotide, _):
            return nucleotide.description
        }
    }
}
