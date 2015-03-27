//
//  DNASequenceType.swift
//  BioSwiftCore
//
//  Created by Alexandre Lopoukhine on 27/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public protocol DNASequenceType {
    typealias N = NucleotideType
    
    var nucleotideArray: [N] {get set}
    var length: Int {get}
    
    init<S: SequenceType where S.Generator.Element == N>(_ nucleotideSequence: S)
    
    subscript (index: Int) -> N {get}
    subscript (subRange: Range<Int>) -> Self {get}
}
