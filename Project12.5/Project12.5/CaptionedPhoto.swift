//
//  CaptionedPhoto.swift
//  Project12.5
//
//  Created by Connor Lee on 13/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import Foundation

class CaptionedPhoto: Codable {
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
