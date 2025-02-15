//
//  HistoryEntry+CoreDataProperties.swift
//  Yap
//
//  Created by TT on 31/04/24.
//
//

import Foundation
import CoreData


extension HistoryEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryEntry> {
        return NSFetchRequest<HistoryEntry>(entityName: "HistoryEntry")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var task_description: String?
    @NSManaged public var duration: String?

}

extension HistoryEntry : Identifiable {

}
