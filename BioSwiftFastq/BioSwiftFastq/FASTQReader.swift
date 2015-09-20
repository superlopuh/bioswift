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
    private static func getFASTQStringsSequenceFromFile(fileAddress: NSURL) throws -> FASTQStringsSequence {
        let fileContent = try NSString(contentsOfURL: fileAddress, encoding: NSUTF8StringEncoding)
        print("FASTQ file length \(fileContent.length)")
        let fastqStringArray = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) 
        return FASTQStringsSequence(stringsSequence: fastqStringArray)
    }
    
    // Get as many FASTQ sequences from start of file as possible
    // Does not check for file being valid
    public static func getArrayFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType) -> [FASTQ] {
        
        var sequences = [FASTQ]()
        do {
            let fileContent = try NSString(contentsOfURL: fileAddress, encoding: NSUTF8StringEncoding)
            
            print("FASTQ file length \(fileContent.length)")
            let fastqStringArray = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            let dateStart = NSDate()
            
            print("Date start: \(dateStart)")
            
            var gen = fastqStringArray.generate()
            while
                let infoString    = gen.next(),
                let dnaString     = gen.next(),
                let _             = gen.next(), // plusString
                let qualityString = gen.next(){
                    if let fastq = FASTQ(fastqInfoString: infoString, dnaString: dnaString, qualityString: qualityString, fastqType: fastqType) {
                        sequences.append(fastq)
                    } else {
                        break
                    }
            }
        } catch {
            print("Error while opening fastq file")
        }
        
        // End of file
        
        print("Date end: \(NSDate())")
        
        return sequences
    }
    
    public static func getArrayFromFile(fileAddress: NSURL, ofFASTQType fastqType: FASTQType, @noescape usingFilter filter: FASTQ -> Bool) throws -> [FASTQ] {
        
        let fastqStringsSequence = try FASTQReader.getFASTQStringsSequenceFromFile(fileAddress)
        
        let numberOfFASTQs = fastqStringsSequence.count
        var fastqRead = 0
        var printed = false
        
        var sequences = [FASTQ]()
        
        let dateStart = NSDate()
        
        print("Date start: \(dateStart)")
        
        for fastqStrings in fastqStringsSequence {
            fastqRead++
            if fastqRead > 100000 && !printed {
                print("100000 fastq parsed")
                print(NSDate())
                
                let secondsElapsed = NSDate().timeIntervalSinceDate(dateStart)
                
                print("Seconds since start: \(secondsElapsed)")
                
                let secondsLeft = secondsElapsed * Double(numberOfFASTQs - 100000)/100000.0
                
                print("Seconds left: \(secondsLeft)")
                
                print("Finish estimate: \(NSDate().dateByAddingTimeInterval(secondsLeft))")
                
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
        
        print("Date end: \(NSDate())")
        
        return sequences
    }
    
    public static func getFASTQDistributionFromFile(fileAddress: NSURL) throws -> FASTQDistribution {
        var aDistribution: [Character:Int] = [:]
        var tDistribution: [Character:Int] = [:]
        var gDistribution: [Character:Int] = [:]
        var cDistribution: [Character:Int] = [:]
        var nDistribution: [Character:Int] = [:]
        
        let fastqStringsSequence = try FASTQReader.getFASTQStringsSequenceFromFile(fileAddress)
        
        for fastqStrings in fastqStringsSequence {
            let dnaArray        = Array(fastqStrings.dnaString.characters)
            let qualityArray    = Array(fastqStrings.qualityString.characters)
            
            assert(dnaArray.count == qualityArray.count, "dnaArray different length to qualityArray: malformed FASTQ file")
            
            let pairArray       = zip(dnaArray, qualityArray)
            for (dnaChar, qualityChar) in pairArray {
                switch dnaChar {
                case Character("A"):
                    aDistribution[qualityChar] = 1 + (aDistribution[qualityChar] ?? 0)
                case Character("T"):
                    tDistribution[qualityChar] = 1 + (tDistribution[qualityChar] ?? 0)
                case Character("G"):
                    gDistribution[qualityChar] = 1 + (gDistribution[qualityChar] ?? 0)
                case Character("C"):
                    cDistribution[qualityChar] = 1 + (cDistribution[qualityChar] ?? 0)
                case Character("N"):
                    nDistribution[qualityChar] = 1 + (nDistribution[qualityChar] ?? 0)
                default:
                    assertionFailure("Surprise character \"\(dnaChar)\" in DNA string")
                }
            }
        }
        
        let distribution = FASTQDistribution(aDistribution: aDistribution, tDistribution: tDistribution, gDistribution: gDistribution, cDistribution: cDistribution, nDistribution: nDistribution)
        return distribution
    }
    
    // Returns a dictionary of probNucleotide to count
    public static func getProbNucleotideDistribution(fileAddress: NSURL, ofFASTQType fastqType: FASTQType) throws -> [ProbNucleotide:Int] {
        var distribution: [ProbNucleotide:Int] = [:]
        
        let fastqStringsSequence = try FASTQReader.getFASTQStringsSequenceFromFile(fileAddress)
        
        let lazySequence = fastqStringsSequence.lazy
        
        let lazyDistributionSequence = lazySequence.map() { (fastqStrings: FASTQStrings) -> [ProbNucleotide:Int] in
            var distribution: [ProbNucleotide:Int] = [:]
            
            let dnaArray        = Array(fastqStrings.dnaString.characters)
            let qualityArray    = Array(fastqStrings.qualityString.characters)
            
            assert(dnaArray.count == qualityArray.count, "dnaArray different length to qualityArray: malformed FASTQ file")
            
            let pairArray       = zip(dnaArray, qualityArray)
            
            for (dnaChar, qualityChar) in pairArray {
                let probNucleotide: ProbNucleotide
                if let nucleotide = Nucleotide(char: dnaChar), let errorProb = fastqType.charToProb(qualityChar) {
                    probNucleotide = ProbNucleotide.Known(nucleotide, errorProb: errorProb)
                } else if Character("N") == dnaChar {
                    // Unknown error probability
                    probNucleotide = .Unknown
                } else {
                    assertionFailure("Could not initialise ProbNucleotide from \(dnaChar)")
                    probNucleotide = .Unknown
                }
                distribution[probNucleotide] = 1 + (distribution[probNucleotide] ?? 0)
            }
            
            return distribution
        }
        
        for dist in lazyDistributionSequence {
            for (probNucleotide, number) in dist {
                distribution[probNucleotide] = number + (distribution[probNucleotide] ?? 0)
            }
        }
        
        return distribution
    }
}
