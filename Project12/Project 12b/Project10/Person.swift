//
//  Person.swift
//  Project10
//
//  Created by Connor Lee on 09/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
