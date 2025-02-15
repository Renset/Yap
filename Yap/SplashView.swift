//
//  SplashView.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import SwiftUI

struct SplashView: View {
    
    // @AppStorage is used to store the isGetStarted flag in UserDefaults
    // This flag tracks whether the user has already clicked the "Get Started" button.
    @AppStorage("isGetStarted") private var isGetStarted : Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                VStack(spacing: 10){
                    Spacer()
                        .frame(height: geometryProxy.size.height/4)
                    // APP Icon.
                    Image("splash_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    // Title.
                    Text("YAP")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    // Sub-Title.
                    Text("Track. Focus. Achieve.")
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .foregroundStyle(Color(hex: "#CAF0F8"))
                    Spacer()
                }
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                .background(Color(hex: "#023E8A")) // View Background color.
                
                getStartedButton()
                    .offset(y: geometryProxy.size.height - 40)
            }
            .navigationDestination(isPresented: $isGetStarted) {
                HomeView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
    
    /// This function creates a "Get Started" button to allow the user to mark they are ready to proceed.
    /// It updates the `isGetStarted` flag to true in UserDefaults when pressed.
    /// - Returns: A Button view configured with the "Get Started" label and style.
    func getStartedButton() -> some View{
        return Button {
            // When the button is pressed, we set isGetStarted to true to navigate to HomeScreen.
            isGetStarted = true
        } label: {
            ZStack{
                Capsule()
                    .foregroundStyle(Color.white)
                
                Text("Get Started")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
        .frame(height: 50)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SplashView()
}
