//
//  TimerDataViewModel.swift
//  Yap
//
//  Created by TharuntejaV on 01/02/25.
//

import Foundation
import UIKit

//class TimerDataViewModel : ObservableObject{
//    @Published var taskList         : [HistoryDataModel]    = []
//    @Published var historyList      : [HistoryDataModel]    = []
//    @Published var selectedTask     : HistoryDataModel?     = nil
//    let taskEntryManager             = TaskEntryManager.shared
//    let historyEntryManager         = HistoryEntryManager.shared
//    
//    func fetchAllTableRecords(){
//        historyList.removeAll()
//        taskList.removeAll()
//        taskEntryManager.retrieveTaskRecords { taskData, error in
//            self.taskList = taskData ?? []
//        }
//        historyEntryManager.retrieveHistoryRecords { historyData, error in
//            self.historyList = historyData ?? []
//        }
//    }
//    
//    func deleteRecordById(uniqueIdentifier : String){
//        taskEntryManager.deleteEvents(id: uniqueIdentifier, completion: {_ in})
//        historyEntryManager.deleteEvents(id: uniqueIdentifier, completion: {_ in})
//    }
//    
//    func createOrUpdateTask(id : String, title: String?, description : String? , duration : String? ){
//        if let _ = taskEntryManager.retriveRecordByIdentifier(uniqueIdentifier: id){
//            taskEntryManager.updateTaskEntry(uniqueIdentifier: id, title: title, description: description, duration: duration, completion: {_ in})
//        }else{
//            taskEntryManager.createTaskEntry(uniqueIdentifier: id, title: title ?? "", description: description ?? "", duration: duration ?? "", completion: {_ in})
//        }
//        fetchAllTableRecords()
//    }
//    
//    func createOrUpdateHistory(id : String, title: String?, description : String? , duration : String? ){
//        if let _ = historyEntryManager.retriveRecordByIdentifier(uniqueIdentifier: id){
//            historyEntryManager.updateHistoryEntry(uniqueIdentifier: id, title: title, description: description, duration: duration, completion: {_ in})
//        }else{
//            historyEntryManager.createHistoryEntry(uniqueIdentifier: id, title: title ?? "", description: description ?? "", duration: duration ?? "", completion: {_ in})
//        }
//        fetchAllTableRecords()
//    }
//}

import Foundation
import UserNotifications
import Combine

class TimerDataViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var taskList: [HistoryDataModel] = []
    @Published var historyList: [HistoryDataModel] = []
    @Published var selectedTask: HistoryDataModel? = nil
    @Published var remainingTime: TimeInterval = 0  // Holds the current time for the timer
    
    let taskEntryManager = TaskEntryManager.shared
    let historyEntryManager = HistoryEntryManager.shared
    var timer: CountdownTimer?
    
    func fetchAllTableRecords() {
        historyList.removeAll()
        taskList.removeAll()
        taskEntryManager.retrieveTaskRecords { taskData, error in
            self.taskList = taskData ?? []
        }
        historyEntryManager.retrieveHistoryRecords { historyData, error in
            self.historyList = historyData ?? []
        }
    }
    
    func deleteRecordById(uniqueIdentifier: String) {
        taskEntryManager.deleteEvents(id: uniqueIdentifier, completion: { _ in })
        historyEntryManager.deleteEvents(id: uniqueIdentifier, completion: { _ in })
    }
    
    func createOrUpdateTask(id: String, title: String?, description: String?, duration: String?) {
        if let _ = taskEntryManager.retriveRecordByIdentifier(uniqueIdentifier: id) {
            taskEntryManager.updateTaskEntry(uniqueIdentifier: id, title: title, description: description, duration: duration, completion: { _ in })
        } else {
            taskEntryManager.createTaskEntry(uniqueIdentifier: id, title: title ?? "", description: description ?? "", duration: duration ?? "", completion: { _ in })
        }
        fetchAllTableRecords()
    }
    
    func createOrUpdateHistory(id: String, title: String?, description: String?, duration: String?) {
        if let _ = historyEntryManager.retriveRecordByIdentifier(uniqueIdentifier: id) {
            historyEntryManager.updateHistoryEntry(uniqueIdentifier: id, title: title, description: description, duration: duration, completion: { _ in })
        } else {
            historyEntryManager.createHistoryEntry(uniqueIdentifier: id, title: title ?? "", description: description ?? "", duration: duration ?? "", completion: { _ in })
        }
        fetchAllTableRecords()
    }
    
    // MARK: - Timer Functions
    
    func startTimer(duration: TimeInterval) {
        UIApplication.shared.isIdleTimerDisabled = true
        // Initialize the timer with a given duration and a completion handler
        timer = CountdownTimer(duration: duration,continuousUpdation: { timeLeft in
            self.remainingTime = timeLeft  // Set the initial time to the duration
        }) { [weak self] in
            self?.timerFinished()
        }
        timer?.begin()  // Start the timer
        guard let selectedTask = selectedTask else { return }
        checkNotificationAuthorizationStatus()
        dispatchNotification(identifier: selectedTask.id, title: selectedTask.title, body: selectedTask.taskDescription, interval: duration)
    }
    
    func pauseTimer() {
        timer?.halt()  // Pause the timer
        removePendingNotification(withIdentifier: selectedTask?.id ?? "")
    }
    
    func resumeTimer() {
        timer?.continueCountdown()  // Resume the timer
    }
    
    func resetTimer() {
        guard let selectedTask = selectedTask else { return }
        let taskDuration = TimeInterval(selectedTask.duration) // Assuming the task has a duration property
        startTimer(duration: taskDuration)  // Reset and start the timer with the task's duration
    }
    
    func stopTimer(){
        // Stop the timer, reset the time, and update the state
        timer?.stop()  // Stop the current timer
        print("Timer Stopped!")
        remainingTime = selectedTask?.duration ?? 0
        // You can perform actions such as saving the task to history or any other logic
        if let task = selectedTask {
            createOrUpdateHistory(id: task.id, title: task.title, description: task.taskDescription, duration: "\(task.duration - remainingTime)")
        }
    }
    
    // MARK: - Helper Function for Timer Finished
    private func timerFinished() {
        // Called when the timer finishes
        print("Timer finished!")
        // You can perform actions such as saving the task to history or any other logic
        if let task = selectedTask {
            createOrUpdateHistory(id: task.id, title: task.title, description: task.taskDescription, duration: "\(remainingTime)")
        }
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert]) { success , error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                print(success.description)
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    

    func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                print("Notification authorization not determined yet.")
                self.requestAuthorization()
            case .denied:
                print("Notification authorization denied.")
                self.requestAuthorization()
            case .authorized, .provisional,.ephemeral:
                print("Notification authorization granted.")
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.banner,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let task = selectedTask {
            createOrUpdateHistory(id: task.id, title: task.title, description: task.taskDescription, duration: "\(remainingTime)")
        }
    }
    
    func dispatchNotification(identifier: String, title: String, body: String,interval: TimeInterval) {
        print(identifier)
        
        let content     = UNMutableNotificationContent()
        content.title   = title
        content.body    = body
        content.sound   = .default
        
        let trigger: UNNotificationTrigger
       
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
                
        // Create notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Notification actions
        let dismissAction = UNNotificationAction(identifier: "\(identifier).dismiss", title: "Dismiss", options: [])
        let category = UNNotificationCategory(identifier: identifier, actions: [dismissAction], intentIdentifiers: [], options: [.customDismissAction])
        
        // Register category and add notification
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled with identifier \(identifier)")
            }
        }
    }

    func removePendingNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Pending notification with identifier \(identifier) has been removed.")
    }


}
