//
//  HomeView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        ZStack {
            // Background with specified color
            BackgroundView(red: 15 / 255, green: 70 / 255, blue: 50 / 255)
            
            // Foreground
            Group {
                VStack {
                    Spacer()
                    ClockView()
                    TextView()
                    SetupView()
                    Spacer()
                    ButtonView()
                }
            }
            .environmentObject(vm)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .frame(maxWidth: 500, maxHeight: .infinity)
            .foregroundColor(.white)
            .onReceive(vm.timer) { _ in
                guard vm.isRunning else { return }
                let _ = print("test")
                if vm.currentTime > 0 {
                    vm.currentTime -= 1
                } else {
                    if vm.isBreak {
                        vm.playSound()
                        vm.isBreak = false
                        vm.pomodoros.append("☕️")
                        vm.currentTime = vm.timerLength
                    } else {
                        vm.playSound()
                        vm.isBreak = true
                        vm.pomodoros.append("🍅")
                        vm.currentTime = vm.breakLength
                    }
                }
            }
            .onReceive([vm.isRunning].publisher.first()) { (value) in print("New value is: \(value)")
                let _ = print("Time: \(vm.currentTime)")
                if !vm.previousIsRunning && value {
                    vm.requestAuthorization()
                    vm.previousIsRunning = value
                    print("Scheduled notification")
                    vm.scheduleNotification()
                }
                if vm.previousIsRunning && !value {
                    vm.previousIsRunning = value
                } else {
                    vm.runHapticFeedback(withStyle: .light)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
