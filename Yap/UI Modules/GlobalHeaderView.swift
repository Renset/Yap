//
//  GlobalHeaderView.swift
//  Yap
//
//  Created by TT on 31/04/24.
//


import SwiftUI

struct GlobalHeaderView: View {
    var isBackButton : Bool
    var title : String
    var isAddTaskView : Bool = false
    @State var navigateToHistory : Bool = false
    var onHistoryButtonPress : (() -> Void)?
    var onDismiss : (() -> Void)?
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack(alignment: .bottom){
                Color.white
                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
                HStack(alignment: .bottom,spacing: 0){
                    Button {
                        onDismiss?()
                    } label: {
                        if isBackButton{
                            Image(isAddTaskView ? "cancel_icon":"back_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }else{
                            Image("splash_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(width: 40, height: 40)
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Text(title)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    if !isBackButton{
                        Button {
                            onHistoryButtonPress?()
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.black)
                                .frame(width: 35, height: 35)
                        }
                        .frame(width: 35, height: 35)
                        .buttonStyle(PlainButtonStyle())
                    }else{
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 30)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
        .frame(height: 90)
    }
}

#Preview {
    GlobalHeaderView(isBackButton: false, title: "")
}
