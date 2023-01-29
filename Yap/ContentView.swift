//
//  ContentView.swift
//  Yap
//
//  Created by Renat Notfullin on 28.01.2023.
//

import AVFoundation
import SwiftUI

struct ContentView: View {

    @State private var timerLength: Float = 25 * 60
    @State private var breakLength: Float = 5 * 60
    @State private var currentTime: Float = 25 * 60
    @State private var isRunning = false
    @State private var isTimer: Bool = true
    @State private var previousIsRunning = false
    @State private var isBreak: Bool = false
    @State private var soundID: Int = 1013
    @State private var isHapticsEnabled: Bool = true
    @State private var isSoundEnabled: Bool = true

    enum HapticStyle {
        case light
        case medium
    }

    func playSound() {
        if isSoundEnabled {
            AudioServicesPlaySystemSound(SystemSoundID(soundID))
        }
    }

    func runHapticFeedback(withStyle style: HapticStyle) {
        if isHapticsEnabled {
            let generator: UIImpactFeedbackGenerator
            switch style {
            case .light:
                generator = UIImpactFeedbackGenerator(style: .light)
            case .medium:
                generator = UIImpactFeedbackGenerator(style: .medium)
            }

            generator.impactOccurred()
        }
    }

    func runHapticSuccessFeedback() {
        if isHapticsEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let gradient = AngularGradient(
        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
        center: .center
    )

    var body: some View {
        ZStack {
            Color(red: 15 / 255, green: 70 / 255, blue: 50 / 255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Yap 🍅")
                        .font(.largeTitle)
                        .padding(.bottom, 30)
                        .alignmentGuide(.leading) { d in d[.leading] }

                    Spacer()
                }

                ZStack {
                    VStack {
                        Text(
                            currentTime != timerLength
                                ? "\(Int((currentTime/60).rounded(.up)))" : "\(Int((timerLength/60).rounded(.up)))"
                        )
                        .font(.system(size: 104))

                        //Text(isTimer ? "minutes" : "minutes left")
                    }

                    Circle()
                        .rotation(.degrees(-90))
                        .stroke(
                            Color.white.opacity(0.3),
                            style: StrokeStyle(lineWidth: 12, dash: [CGFloat.pi / 2, CGFloat.pi * 3.5])
                        )

                        .frame(width: 240, height: 240)

                    Circle()
                        .trim(
                            from: 0,
                            to: CGFloat(((currentTime).truncatingRemainder(dividingBy: 60) - 0.25) / 60)
                        )
                        .rotation(.degrees(-90))
                        .stroke(
                            Color.white.opacity(0.8),
                            style: StrokeStyle(lineWidth: 12, dash: [CGFloat.pi / 2, CGFloat.pi * 3.5])
                        )
                        .frame(width: 240, height: 240)

                }

                HStack {
                    Text("Work: \(Int(timerLength/60)) min")
                        .frame(minWidth: 120, alignment: .leading)

                    Slider(
                        value: $timerLength,
                        in: 60...60 * 60,
                        step: 60,
                        onEditingChanged: { _ in
                            currentTime = timerLength

                            runHapticSuccessFeedback()
                        }
                    ).tint(Color.yellow).disabled(isRunning)
                }
                HStack {
                    Text("Break: \(Int(breakLength/60)) min").frame(minWidth: 120, alignment: .leading)
                    Slider(
                        value: $breakLength,
                        in: 60...60 * 20,
                        step: 60,
                        onEditingChanged: { _ in
                            runHapticSuccessFeedback()
                        }
                    ).tint(Color.yellow).disabled(isRunning)
                }

                Toggle(isOn: $isHapticsEnabled) {
                    Text("Haptics")
                }.tint(Color.yellow)

                Toggle(isOn: $isSoundEnabled) {
                    Text("Sounds")
                }.tint(Color.yellow)

                Spacer()

                Button(action: {
                    self.isRunning.toggle()
                    if self.isRunning {
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    else {
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                }.padding(.bottom, 30)

            }.onReceive(timer) { _ in
                guard self.isRunning else { return }
                let _ = print("test")
                if self.currentTime > 0 {
                    self.currentTime -= 1
                }
                else {
                    if self.isBreak {
                        playSound()
                        self.isTimer.toggle()
                        self.currentTime = self.isTimer ? self.timerLength : self.breakLength
                    }
                    else {
                        playSound()
                        self.isBreak = true
                        self.currentTime = self.breakLength
                    }

                }
            }.onReceive([self.isRunning].publisher.first()) { (value) in print("New value is: \(value)")

                let _ = print("Time: \(currentTime)")
                if previousIsRunning && !value {
                    previousIsRunning = value
                }
                else {
                    runHapticFeedback(withStyle: .light)
                }

            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .frame(maxWidth: 500, maxHeight: .infinity)
            .foregroundColor(.white)
        }
        .preferredColorScheme(.dark)

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
