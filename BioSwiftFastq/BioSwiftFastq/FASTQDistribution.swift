//
//  FASTQDistribution.swift
//  BioSwiftFastq
//
//  Created by Alexandre Lopoukhine on 19/04/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

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
}
