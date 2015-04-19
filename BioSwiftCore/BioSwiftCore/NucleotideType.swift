//
//  NucleotideType.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 27/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public protocol NucleotideType: Printable {
    func probOfMatchWithNucleotide(nucleotide: Nucleotide) -> Double
    var complement: Self {get}
}
