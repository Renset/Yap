//
//  HomeViewModel.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import Foundation
import AVFoundation
import SwiftUI
import UserNotifications

class HomeViewModel: ObservableObject {
    // MARK: Variables for HomeView
    @Published var timerLength: Float = 25 * 60
    @Published var breakLength: Float = 5 * 60
    @Published var currentTime: Float = 25 * 60
    @Published var isRunning = false
    @Published var isStarted = false
    @Published var previousIsRunning = false
    @Published var isBreak: Bool = false
    @Published var soundID: Int = 1013
    @AppStorage("isHapticsEnabled") var isHapticsEnabled: Bool = true
    @AppStorage("isSoundEnabled") var isSoundEnabled: Bool = true
    @Published var pomodoros = [String]()
    
    // MARK: Local Variables
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
        center: .center
    )
    enum HapticStyle {
        case light
        case medium
    }
    
    // MARK: Methods
    func playSound() {
        if self.isSoundEnabled {
            AudioServicesPlaySystemSound(SystemSoundID(self.soundID))
        }
    }
    
    func runHapticFeedback(withStyle style: HapticStyle) {
        guard isHapticsEnabled else { return }
        let generator: UIImpactFeedbackGenerator
        switch style {
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)
        }
        generator.impactOccurred()
    }

    func runHapticSuccessFeedback() {
        guard isHapticsEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted.")
            }
            else {
                print("Notification authorization denied.")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.subtitle = "Your pomodoro timer has finished"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: Double(self.currentTime),
            repeats: false
        )

        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(
            identifier: uuidString,
            content: content,
            trigger: trigger
        )

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            print("Notification request added")
            if error != nil {
                print("Error occured: " + error!.localizedDescription)
            }

        }
    }
}
