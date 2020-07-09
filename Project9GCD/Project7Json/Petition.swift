//
//  Petition.swift
//  Project7Json
//
//  Created by Connor Lee on 03/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
