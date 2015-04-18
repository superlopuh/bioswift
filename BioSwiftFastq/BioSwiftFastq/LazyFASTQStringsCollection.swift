//
//  LazyFASTQStringsCollection.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 18/04/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

struct LazyFASTQStringsCollection: SequenceType {
    private var stringsCollection: SequenceOf<String>
    
    func generate() -> GeneratorOf<FASTQStrings> {
        var gen = stringsCollection.generate()
        
        return GeneratorOf<FASTQStrings> {
            if
                let infoString    = gen.next(),
                let dnaString     = gen.next(),
                let plusString    = gen.next(),
                let qualityString = gen.next(){
                    return FASTQStrings(fastqInfoString: infoString, dnaString: dnaString, qualityString: qualityString)
            } else {
                return nil
            }
        }
    }
}
