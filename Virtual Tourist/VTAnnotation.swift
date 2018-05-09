//
//  VTAnnotation.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation
import MapKit

class VTAnnotation : NSObject, MKAnnotation {
    var pin: Pin
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.long)
    }
    var title: String?
    var subtitle: String?
    
    init(pin: Pin) {
        self.pin = pin
    }
    
}
