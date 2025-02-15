//
//  TimerManager.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import SwiftUI
import Combine

// Timer model that can be resumed, paused, and reset
class CountdownTimer: ObservableObject {
    
    @Published var timeLeft    : TimeInterval
    @Published var isStopped   : Bool = true
    var countdown: AnyCancellable?
    var completionHandler: () -> Void
    var continuousUpdationHandler : (TimeInterval) -> Void
    var initialTime: TimeInterval
    var shouldRepeat: Bool = false
    
    init(duration: TimeInterval,continuousUpdation : @escaping (TimeInterval) -> Void, completion: @escaping () -> Void) {
        self.initialTime = duration
        self.timeLeft = duration
        self.completionHandler = completion
        self.continuousUpdationHandler = continuousUpdation
    }
    
    // Begin the countdown if it is not already running
    func begin() {
        guard timeLeft > 0 else { return }
        startCountdown()
        isStopped = false
    }
    
    // Halt the countdown
    func halt() {
        countdown?.cancel()
        isStopped = true
    }
    
    // Continue the countdown
    func continueCountdown() {
        guard timeLeft > 0 else { return }
        startCountdown()
        isStopped = false
    }
    
    // Restart the countdown from the original time and start it
    func restart() {
        countdown?.cancel()
        timeLeft = initialTime
        begin()
    }
    
    // Stop the countdown completely
    func stop() {
        countdown?.cancel()
        isStopped = true
    }

    private func startCountdown() {
        countdown?.cancel()
        countdown = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeLeft > 0 {
                    self.timeLeft -= 1
                    self.continuousUpdationHandler(timeLeft)
                } else {
                    self.timeLeft = 0
                    self.completionHandler()
                    self.stop()
                }
            }
    }
}
