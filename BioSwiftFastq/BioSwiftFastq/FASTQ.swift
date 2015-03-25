//
//  FASTQ.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

public struct FASTQ {
    let fastqType: FASTQType
    
    // Original Info
    let fastqInfoString: String
    let dnaString: String
    let qualityString: String
    
    // Derived structure
    let probDNASequence: ProbDNASequence
    
    public init?(fastqInfoString: String, dnaString: String, qualityString: String, fastqType: FASTQType) {
        self.fastqType          = fastqType
        
        self.fastqInfoString    = fastqInfoString
        self.dnaString          = dnaString
        self.qualityString      = qualityString
        
        // Convert qualityString to probability array
        let optionalErrorProbArray = Array(qualityString).map() {
            return fastqType.charToProb($0)
        }
        
        if let errorProbArray = unwrap(optionalErrorProbArray) {
            if let probDNASequence = ProbDNASequence(dnaString: dnaString, errorProbArray: errorProbArray) {
                self.probDNASequence = probDNASequence
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
