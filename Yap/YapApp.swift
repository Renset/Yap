//
//  YapApp.swift
//  Yap
//
//  Created by Renat Notfullin on 28.01.2023.
//

import SwiftUI

@main
struct YapApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var timerDataViewModel = TimerDataViewModel()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerDataViewModel)
        }
    }
}
