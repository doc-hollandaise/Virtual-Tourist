//
//  Pin+Extensions.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation
import CoreData

extension Pin {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
