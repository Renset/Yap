//
//  StringExtension.swift
//  Yap
//
//  Created by TT on 31/04/24.
//
import Foundation
import UIKit

extension String {
    /// Converts a time string (e.g., "02:30", "1:45:20") into a `TimeInterval` (seconds).
    func toTimeInterval() -> TimeInterval? {
        let cleanedString = self.replacingOccurrences(of: " ", with: "") // Remove spaces
        let components = cleanedString.components(separatedBy: ":").reversed()
        
        var totalSeconds: TimeInterval = 0
        let multipliers: [TimeInterval] = [1, 60, 3600] // Seconds, Minutes, Hours
        
        for (index, component) in components.enumerated() {
            guard index < multipliers.count, let value = TimeInterval(component) else { return nil }
            totalSeconds += value * multipliers[index]
        }
        
        return totalSeconds
    }
}


