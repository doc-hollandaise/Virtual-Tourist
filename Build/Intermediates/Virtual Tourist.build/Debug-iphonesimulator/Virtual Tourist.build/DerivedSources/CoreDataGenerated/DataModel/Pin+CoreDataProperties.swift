//
//  Pin+CoreDataProperties.swift
//  
//
//  Created by Derek Justus on 5/9/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension Pin {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Photo)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Photo)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
