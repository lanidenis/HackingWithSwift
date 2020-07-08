//
//  Person.swift
//  Names To Faces
//
//  Created by Jelani Denis on 6/26/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
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
