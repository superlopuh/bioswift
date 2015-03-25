//
//  FASTQReader.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 25/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

public class FASTQReader {
    // Get as many FASTQ sequences from start of file as possible
    // Does not check for file being valid
    public static func getArrayFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType) -> [FASTQ] {
        
        var sequences = [FASTQ]()
        
        if let fileContent = NSString(contentsOfURL: fileAddress, encoding: NSUTF8StringEncoding, error: nil) {
            println(fileContent.length)
            let fastqStringArray = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as! [String]
            
            var gen = fastqStringArray.generate()
            while
                let infoString    = gen.next(),
                let dnaString     = gen.next(),
                let plusString    = gen.next(),
                let qualityString = gen.next(){
                    if let fastq = FASTQ(fastqInfoString: infoString, dnaString: dnaString, qualityString: qualityString, fastqType: fastqType) {
                        sequences.append(fastq)
                    } else {
                        break
                    }
            }
        }
        // End of file
        
        return sequences
    }
    
    public static func getArrayFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType, @noescape usingFilter filter: FASTQ -> Bool) -> [FASTQ] {
        
        var sequences = [FASTQ]()
        
        if let fileContent = NSString(contentsOfURL: fileAddress, encoding: NSUTF8StringEncoding, error: nil) {
            println("FASTQ file length \(fileContent.length)")
            let fastqStringArray = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as! [String]
            
            let numberOfLines = fastqStringArray.count
            var linesRead = 0
            var printed = false
            
            let dateStart = NSDate()
            
            var gen = fastqStringArray.generate()
            while
                let infoString    = gen.next(),
                let dnaString     = gen.next(),
                let plusString    = gen.next(),
                let qualityString = gen.next(){
                    linesRead += 4
                    if linesRead > 100000 && !printed {
                        println("100000 lines parsed")
                        println(NSDate().timeIntervalSinceDate(dateStart))
                        printed = true
                    }
                    if let fastq = FASTQ(fastqInfoString: infoString, dnaString: dnaString, qualityString: qualityString, fastqType: fastqType) {
                        if filter(fastq) {
                            sequences.append(fastq)
                        }
                    } else {
                        break
                    }
            }
        }
        // End of file
        
        return sequences
    }
}
