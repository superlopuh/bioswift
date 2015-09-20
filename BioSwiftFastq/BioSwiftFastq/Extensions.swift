//
//  Extensions.swift
//  SpaTyper
//
//  Created by Alexandre Lopoukhine on 24/03/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation


// My Foundation extensions


func unwrap<T>(array: [T?]) -> [T]? {
    var newArray = [T]()
    var gen = array.generate()
    while let el = gen.next() {
        if let element = el {
            newArray.append(element)
        } else {
            return nil
        }
    }
    return newArray
}

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    func map<OutKey: Hashable, OutValue>(transform: Element -> (OutKey, OutValue)) -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(self.map(transform))
    }
    
    func filter(includeElement: Element -> Bool) -> [Key: Value] {
        return Dictionary(self.filter(includeElement))
    }
}
