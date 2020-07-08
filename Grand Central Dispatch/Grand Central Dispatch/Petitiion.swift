//
//  Petitiion.swift
//  Whitehouse Petitions
//
//  Created by Jelani Denis on 6/12/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
