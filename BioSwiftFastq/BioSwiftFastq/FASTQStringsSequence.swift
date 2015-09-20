//
//  FASTQStringsSequence.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 18/04/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

struct FASTQStringsSequence: SequenceType {
    private var stringsSequence: [String]
    
    internal var count: Int
    
    internal init(stringsSequence: [String]) {
        self.stringsSequence    = stringsSequence
        self.count              = stringsSequence.count/4
    }
    
    func generate() -> AnyGenerator<FASTQStrings> {
        var gen = stringsSequence.generate()
        
        return anyGenerator() { () -> FASTQStrings? in
            if
                let infoString      = gen.next(),
                let dnaString       = gen.next(),
                let _               = gen.next(),
                let qualityString   = gen.next() {
                    return FASTQStrings(fastqInfoString: infoString, dnaString: dnaString, qualityString: qualityString)
            } else {
                return nil
            }
        }
    }
}
