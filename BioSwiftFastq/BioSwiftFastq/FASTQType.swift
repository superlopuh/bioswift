//
//  FASTQType.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 23/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

// All info from here:
// http://en.wikipedia.org/wiki/FASTQ_format

public enum FASTQType {
    case Illumina18, Illumina15, Sanger
    
    public func getPhred() -> Int {
        switch self {
        case .Sanger:
            return 33
        case .Illumina18:
            return 33
        case .Illumina15:
            return 64
        }
    }
    
}
