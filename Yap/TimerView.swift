//
//  HomeView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var homeVM = HomeViewModel()
    @EnvironmentObject private var timerDataVM : TimerDataViewModel
   
    var body: some View {
        ZStack {
            // Background with specified color
            BackgroundView(red: 15 / 255, green: 70 / 255, blue: 50 / 255)
            
            // Foreground
            GeometryReader { geometry in
                ScrollView(showsIndicators: false){
                    VStack {
                        Spacer()
                        ClockView()
                        TextView()
                        SetupView()
                        Spacer()
                        ButtonView()
                    }
                    .environmentObject(homeVM)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(.white)
                    .onReceive(homeVM.timer) { _ in
                        guard homeVM.isRunning else { return }
                        let _ = print("test")
                        if homeVM.currentTime > 0 {
                            homeVM.currentTime -= 1
                        } else {
                            if homeVM.isBreak {
                                homeVM.playSound()
                                homeVM.isBreak = false
                                homeVM.pomodoros.append("☕️")
                                homeVM.currentTime = homeVM.timerLength
                            } else {
                                homeVM.playSound()
                                homeVM.isBreak = true
                                homeVM.pomodoros.append("🍅")
                                homeVM.currentTime = homeVM.breakLength
                            }
                        }
                    }
                    .onReceive([homeVM.isRunning].publisher.first()) { (value) in print("New value is: \(value)")
                        let _ = print("Time: \(homeVM.currentTime)")
                        if !homeVM.previousIsRunning && value {
                            homeVM.requestAuthorization()
                            homeVM.previousIsRunning = value
                            print("Scheduled notification")
                            homeVM.scheduleNotification()
                        }
                        if homeVM.previousIsRunning && !value {
                            homeVM.previousIsRunning = value
                        } else {
                            homeVM.runHapticFeedback(withStyle: .light)
                        }
                    }
                }
                .preferredColorScheme(.dark)
                .onAppear {
                    timerDataVM.remainingTime = TimeInterval(timerDataVM.selectedTask?.duration ?? 0)
                }
            }
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
