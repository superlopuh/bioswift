//
//  FASTQReader.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 25/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation
import BioSwiftCore

public class FASTQReader {
    // Get as many FASTQ sequences from start of file as possible
    // Does not check for file being valid
    private static func getFASTQStringsSequenceFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType) -> FASTQStringsSequence {
        if let fileContent = NSString(contentsOfURL: fileAddress, encoding: NSUTF8StringEncoding, error: nil) {
            println("FASTQ file length \(fileContent.length)")
            let fastqStringArray = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as! [String]
            return FASTQStringsSequence(stringsSequence: fastqStringArray)
        } else {
            return FASTQStringsSequence(stringsSequence: [String]())
        }
    }
    
    // Get as many FASTQ sequences from start of file as possible
    // Does not check for file being valid
    public static func getArrayFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType) -> [FASTQ] {
        
        var sequences = [FASTQ]()
        
        if let fileContent = NSString(contentsOfURL: fileAddress, encoding: NSUTF8StringEncoding, error: nil) {
            println("FASTQ file length \(fileContent.length)")
            let fastqStringArray = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as! [String]
            
            let dateStart = NSDate()
            
            println("Date start: \(dateStart)")
            
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
        
        println("Date end: \(NSDate())")
        
        return sequences
    }
    
    public static func getArrayFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType, @noescape usingFilter filter: FASTQ -> Bool) -> [FASTQ] {
        
        let fastqStringsSequence = FASTQReader.getFASTQStringsSequenceFromFile(fileAddress, ofFASTQType: fastqType)
        
        let numberOfFASTQs = fastqStringsSequence.count
        var fastqRead = 0
        var printed = false
        
        var sequences = [FASTQ]()
        
        let dateStart = NSDate()
        
        println("Date start: \(dateStart)")
        
        for fastqStrings in fastqStringsSequence {
            fastqRead++
            if fastqRead > 100000 && !printed {
                println("100000 fastq parsed")
                println(NSDate())
                
                let secondsElapsed = NSDate().timeIntervalSinceDate(dateStart)
                
                println("Seconds since start: \(secondsElapsed)")
                
                let secondsLeft = secondsElapsed * Double(numberOfFASTQs - 100000)/100000.0
                
                println("Seconds left: \(secondsLeft)")
                
                println("Finish estimate: \(NSDate().dateByAddingTimeInterval(secondsLeft))")
                
                printed = true
            }
            if let fastq = FASTQ(fastqInfoString: fastqStrings.fastqInfoString, dnaString: fastqStrings.dnaString, qualityString: fastqStrings.qualityString, fastqType: fastqType) {
                if filter(fastq) {
                    sequences.append(fastq)
                }
            } else {
                break
            }
        }
        // End of file
        
        println("Date end: \(NSDate())")
        
        return sequences
    }
    
    // Returns a dictionary of probNucleotide to count
    public static func getProbNucleotideDistribution(fileAddress: NSURL, ofFASTQType fastqType: FASTQType) -> [ProbNucleotide:Int] {
        var distribution: [ProbNucleotide:Int] = [:]
        
        let fastqArray = FASTQReader.getArrayFromFile(fileAddress, ofFASTQType: fastqType)
        
        for fastq in fastqArray {
            for probNucleotide in fastq.probDNASequence.nucleotideArray {
                distribution[probNucleotide] = 1 + (distribution[probNucleotide] ?? 0)
            }
        }
        
        return distribution
    }
}
