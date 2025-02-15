//
//  TextExtension.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import SwiftUI

extension Text{
    static func timeFormatter(from timeInterval: TimeInterval, placeholderText: String = "") -> Text {
        let time = NSInteger(timeInterval)
        
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        
        if timeInterval <= 0 {
            return Text(placeholderText)
        }
        
        if hours > 0 {
            return Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
        } else {
            return Text(String(format: "%02d:%02d", minutes, seconds))
        }
    }
}
