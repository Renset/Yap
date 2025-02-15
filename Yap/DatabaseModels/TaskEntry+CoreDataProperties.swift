//
//  TaskEntry+CoreDataProperties.swift
//  Yap
//
//  Created by TT on 31/04/24.
//
//

import Foundation
import CoreData


extension TaskEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntry> {
        return NSFetchRequest<TaskEntry>(entityName: "TaskEntry")
    }

    @NSManaged public var duration: String?
    @NSManaged public var id: String?
    @NSManaged public var task_description: String?
    @NSManaged public var title: String?

}

extension TaskEntry : Identifiable {

}
