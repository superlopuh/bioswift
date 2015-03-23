//
//  FASTQ.swift
//  bioswift-fastq
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

public struct FASTQ {
    // Original Info
    let fastqInfoString: String
    let dnaString: String
    let qualityString: String
    
    // Derived structure
//    let probDNASequence: ProbDNASequence
}

let hello = Nucleotide(Character("A"))
