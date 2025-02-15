//
//  HistoryView.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import SwiftUI

struct HistoryView : View {
    @EnvironmentObject var timerDataVM : TimerDataViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { geometryProxy in
            VStack(spacing: 0){
                GlobalHeaderView(isBackButton: true, title: "History", onDismiss: {
                        presentationMode.wrappedValue.dismiss()
                })
                
                //List Content.
                List(timerDataVM.historyList,id: \.self){ list in
                    HStack{
                        VStack(alignment: .leading,spacing: 6){
                            Text(list.title)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.black)
                            
                            Text(list.taskDescription)
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .foregroundStyle(Color.black.opacity(0.8))
                            
                        }
                        .padding([.horizontal,.vertical], 10)
                        
                        Spacer()
                        
                        Text(list.duration.toTimeString())
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                            .listRowBackground(Color.clear)
                            .padding(.trailing, 10)
                    }
                    .background(Color(hex: "#F3B817"))
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .listRowSeparator(.hidden)
                }
                .background(Color(hex: "#CAF0F8"))
                .listStyle(.plain)
            }
            .ignoresSafeArea()
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            .background(Color(hex: "#CAF0F8")) // View Background color.
        }
    }
}
