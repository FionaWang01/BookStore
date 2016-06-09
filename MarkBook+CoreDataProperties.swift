//
//  MarkBook+CoreDataProperties.swift
//  BookStore
//
//  Created by babykang on 6/9/16.
//  Copyright © 2016 babykang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MarkBook {

    @NSManaged var authName: String?
    @NSManaged var bookImage: String?
    @NSManaged var bookName: String?
    @NSManaged var data: NSDate?

}
