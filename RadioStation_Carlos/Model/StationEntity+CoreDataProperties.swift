//
//  StationEntity+CoreDataProperties.swift
//  RadioStation_Carlos
//
//  Created by cmu on 13/05/2020.
//  Copyright © 2020 UPV. All rights reserved.
//
//

import Foundation
import CoreData


extension StationEntity {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<StationEntity> {
        return NSFetchRequest<StationEntity>(entityName: "StationEntity")
    }

    @NSManaged public var imageURL: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String
    @NSManaged public var streamURL: String

}
