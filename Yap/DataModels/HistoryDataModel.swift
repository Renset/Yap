//
//  HistoryDataModel.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import UIKit

struct HistoryDataModel : Hashable {
    var id              : String
    var title           : String
    var taskDescription : String
    var duration        : TimeInterval
}
