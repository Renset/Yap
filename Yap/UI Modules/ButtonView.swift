//
//  ButtonView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                vm.isRunning.toggle()
                vm.isStarted.toggle()
                if vm.isRunning {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                else {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            }) {
                Text(vm.isRunning || vm.isStarted ? "Stop" : "Start").font(.system(size: 24))
            }.padding(.trailing).padding(.bottom, 30)

            if vm.isStarted {
                Button(action: {
                    vm.isRunning.toggle()
                    if vm.isRunning {
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    else {
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
                }) {
                    Text(vm.isRunning ? "Pause" : "Continue").font(.system(size: 24))
                }.padding(.bottom, 30)
            }
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
