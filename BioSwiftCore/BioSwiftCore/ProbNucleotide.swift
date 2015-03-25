//
//  ProbNucleotide.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 24/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public enum ProbNucleotide {
    case Unknown
    case Known(Nucleotide, Double)
}
