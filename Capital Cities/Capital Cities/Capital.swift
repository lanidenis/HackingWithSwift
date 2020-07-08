//
//  Capital.swift
//  Capital Cities
//
//  Created by Jelani Denis on 7/8/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
