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
