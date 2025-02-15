//
//  TimeIntervalExtension.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation

extension TimeInterval {
    /// Converts a TimeInterval (seconds) into a formatted time string.
    /// - Returns: A string in "hh:mm:ss", "mm:ss", or "ss" format.
    func toTimeString() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

