//
//  ButtonView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject private var timerDataVM: TimerDataViewModel
    
    var body: some View {
        HStack {
            Button(action: {
//                vm.isRunning.toggle()
//                vm.isStarted.toggle()
//                if vm.isRunning {
//                    UIApplication.shared.isIdleTimerDisabled = true
//                }
//                else {
//                    UIApplication.shared.isIdleTimerDisabled = false
//                }
                if timerDataVM.timer?.isStopped ?? true {
                    timerDataVM.startTimer(duration: timerDataVM.selectedTask?.duration ?? 0)
                }else{
                    timerDataVM.stopTimer()
                }
            }) {
                Text(timerDataVM.timer?.isStopped ?? true ? "Start" : "Stop").font(.system(size: 24))
            }.padding(.trailing).padding(.bottom, 30)

//            if timerDataVM.timer?.isStopped ?? true {
//                Button(action: {
////                    vm.isRunning.toggle()
//                    timerDataVM.pauseTimer()
////                    if vm.isRunning {
////                        UIApplication.shared.isIdleTimerDisabled = true
////                    }
////                    else {
////                        UIApplication.shared.isIdleTimerDisabled = false
////                    }
//                }) {
//                    Text(timerDataVM.timer?.isStopped ?? true ? "Pause" : "Continue").font(.system(size: 24))
//                }.padding(.bottom, 30)
//            }
        }
    }
}

struct ButtonView_Preview: PreviewProvider {
    private static var vm = HomeViewModel()
    static var previews: some View {
        ButtonView()
            .environmentObject(vm)
    }
}
