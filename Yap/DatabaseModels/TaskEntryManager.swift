//
//  TaskEntryManager.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import CoreData

class TaskEntryManager : NSObject{
    
    static let shared = TaskEntryManager()
    private override init(){}
    let context = PersistenceController.shared.container.viewContext
    
    func createTaskEntry(uniqueIdentifier: String,title: String,description : String,duration : String,completion: @escaping (Error?) -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TaskEntry", in: context) else {
            completion(nil)
            return
        }
        let eventDetails = NSManagedObject(entity: entity, insertInto: context)
        eventDetails.setValue(uniqueIdentifier, forKey: "id")
        eventDetails.setValue(title, forKey: "title")
        eventDetails.setValue(description, forKey: "task_description")
        eventDetails.setValue(duration, forKey: "duration")
        
        do {
            try context.save()
            print("Created event with \(uniqueIdentifier)")
            completion(nil)
        } catch {
            print("Failed to create event with \(uniqueIdentifier)")
            completion(error)
        }
    }
    
    func retriveRecordByIdentifier(uniqueIdentifier : String) -> TaskEntry?{
        let fetchRequest : NSFetchRequest<TaskEntry> = TaskEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uniqueIdentifier)
        do{
            let historyRecord = try context.fetch(fetchRequest)
            return historyRecord.count > 0 ? historyRecord.first : nil
        }catch{
            print(error)
            return nil
        }
    }
    
    func retrieveTaskRecords(completion: @escaping ([HistoryDataModel]?, Error?) -> Void) {
        do {
            let fetchRequest : NSFetchRequest<TaskEntry> = TaskEntry.fetchRequest()
            let result = try! context.fetch(fetchRequest)
            var taskRecords : [HistoryDataModel] = []
            for eventsList in result {
                
                if let title = eventsList.title,
                   let description = eventsList.task_description,
                   let duration = eventsList.duration,
                   let id = eventsList.id
                {
                    
                    taskRecords.append(HistoryDataModel(id: id, title: title, taskDescription: description, duration: duration.toTimeInterval() ?? 0))
                }
            }
            completion(taskRecords, nil)
            
        } catch {
            completion(nil, error)
        }
    }
    
    
    func updateTaskEntry(uniqueIdentifier: String,title: String?,description : String?,duration : String?,completion: @escaping (Error?) -> Void){
        if let record = retriveRecordByIdentifier(uniqueIdentifier: uniqueIdentifier){
            if let title = title{
                record.title = title
            }
            
            if let description = description{
                record.task_description = description
            }
            
            if let duration = duration{
                record.duration = duration
            }
        }
    }
    
    func deleteEvents(id: String,completion: @escaping (Error?) -> Void) {
        let fetchRequest : NSFetchRequest<TaskEntry> = TaskEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        do {
            let dataFetched = try context.fetch(fetchRequest)
            if let deleteObj = dataFetched.first {
                context.delete(deleteObj)
                try context.save()
            }
            print("removed record")
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteAllEvents(id: String, completion: @escaping (Error?) -> Void) {
        let fetchRequest : NSFetchRequest<TaskEntry> = TaskEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let dataFetched = try context.fetch(fetchRequest)
            for deleteObj in dataFetched {
                context.delete(deleteObj)
            }
            try context.save()
            print("removed record")
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

