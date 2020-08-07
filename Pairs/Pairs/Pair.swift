//
//  Pair.swift
//  Pairs
//
//  Created by Connor Lee on 07/08/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import Foundation

struct Pair: Equatable {
    var pair1: String
    var pair2: String
    
    static func ==(lhs:Pair, rhs:Pair) -> Bool { // Implement Equatable
        return lhs.pair1 == rhs.pair1 && lhs.pair2 == rhs.pair2
    }
}
