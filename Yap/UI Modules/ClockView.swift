//
//  ClockView.swift
//  Yap
//
//  Created by Timo Köthe on 29.05.24.
//

import SwiftUI

struct ClockView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            // Digit Counter
            Text(
                vm.currentTime != vm.timerLength
                ? "\(Int((vm.currentTime/60).rounded(.up)))" : "\(Int((vm.timerLength/60).rounded(.up)))"
            )
            .font(.system(size: 160, weight: .thin))
            
            // Circle Counter
            Group {
                Circle()
                    .rotation(.degrees(-90))
                    .stroke(
                        Color.white.opacity(0.3),
                        style: StrokeStyle(lineWidth: 12, dash: [CGFloat.pi / 2, CGFloat.pi * 3.5])
                    )
                Circle()
                    .trim(
                        from: 0,
                        to: CGFloat(((vm.currentTime).truncatingRemainder(dividingBy: 60) - 0.25) / 60)
                    )
                    .rotation(.degrees(-90))
                    .stroke(
                        Color.white.opacity(0.8),
                        style: StrokeStyle(lineWidth: 12, dash: [CGFloat.pi / 2, CGFloat.pi * 3.5])
                    )
            }
            .frame(width: 240, height: 240)
        }
    }
}

struct ClockView_Preview: PreviewProvider {
    private static var vm = HomeViewModel()
    static var previews: some View {
        ClockView()
            .environmentObject(vm)
            .background(.gray)
    }
}
