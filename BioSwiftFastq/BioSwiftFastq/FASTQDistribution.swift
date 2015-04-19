//
//  FASTQDistribution.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 19/04/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

private let aDistKey = "aDistribution"
private let tDistKey = "tDistribution"
private let gDistKey = "gDistribution"
private let cDistKey = "cDistribution"
private let nDistKey = "nDistribution"

public class FASTQDistribution {
    public let aDistribution: [Character:Int]
    public let tDistribution: [Character:Int]
    public let gDistribution: [Character:Int]
    public let cDistribution: [Character:Int]
    public let nDistribution: [Character:Int]
    
    public init(aDistribution: [Character:Int], tDistribution: [Character:Int], gDistribution: [Character:Int], cDistribution: [Character:Int], nDistribution: [Character:Int]) {
        self.aDistribution = aDistribution
        self.tDistribution = tDistribution
        self.gDistribution = gDistribution
        self.cDistribution = cDistribution
        self.nDistribution = nDistribution
    }
    
    public func writeToPlist(atPath filePath: String) {
        var dict: NSMutableDictionary = [:]
        
        // Character is not a serialisable type, have to map to String
        let myADist = aDistribution.map {
            return (String($0), $1)
        }
        let myTDist = tDistribution.map {
            return (String($0), $1)
        }
        let myGDist = gDistribution.map {
            return (String($0), $1)
        }
        let myCDist = cDistribution.map {
            return (String($0), $1)
        }
        let myNDist = nDistribution.map {
            return (String($0), $1)
        }
        
        // Set values to the dictionary being written
        dict.setObject(myADist, forKey: aDistKey)
        dict.setObject(myTDist, forKey: tDistKey)
        dict.setObject(myGDist, forKey: gDistKey)
        dict.setObject(myCDist, forKey: cDistKey)
        dict.setObject(myNDist, forKey: nDistKey)
        
        dict.writeToFile(filePath, atomically: false)
        
        // Test that everything was written correctly
        let resultDict = NSMutableDictionary(contentsOfFile: filePath)
        println("Saved distribution:\n\(resultDict)")
    }
}
