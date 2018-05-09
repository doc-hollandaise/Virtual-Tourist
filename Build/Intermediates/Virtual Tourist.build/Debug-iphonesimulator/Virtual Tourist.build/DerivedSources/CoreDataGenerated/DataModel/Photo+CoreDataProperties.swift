//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Derek Justus on 5/9/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var pin: Pin?

}
