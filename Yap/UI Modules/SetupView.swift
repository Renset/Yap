//
//  SetupView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Work: \(Int(vm.timerLength/60)) min")
                    .frame(minWidth: 120, alignment: .leading)
                Slider(
                    value: $vm.timerLength,
                    in: 60...60 * 60,
                    step: 60,
                    onEditingChanged: { _ in
                        vm.currentTime = vm.timerLength
                        vm.runHapticSuccessFeedback()
                    }
                )
                .tint(.yellow)
                .disabled(vm.isRunning)
            }
            HStack {
                Text("Break: \(Int(vm.breakLength/60)) min")
                    .frame(minWidth: 120, alignment: .leading)
                
                Slider(
                    value: $vm.breakLength,
                    in: 60...60 * 20,
                    step: 60,
                    onEditingChanged: { _ in
                        vm.runHapticSuccessFeedback()
                    }
                )
                .tint(.yellow)
                .disabled(vm.isRunning)
            }
            
            Group {
                Toggle("Haptics", isOn: $vm.isHapticsEnabled)
                Toggle("Sounds", isOn: $vm.isSoundEnabled)
            }
            .tint(.yellow)
        }
    }
}

struct SetupView_Preview: PreviewProvider {
    private static var vm = HomeViewModel()
    static var previews: some View {
        SetupView()
            .environmentObject(vm)
    }
}
