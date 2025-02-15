//
//  HomeView.swift
//  Yap
//
//  Created by TT on 31/04/24.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var timerDataVM : TimerDataViewModel
    @State var navigateToTimerView     : Bool = false
    @State var presentAddTaskView      : Bool = false
    @State var navigateToHistory       : Bool = false
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack(spacing: 0){
                //Header View
                GlobalHeaderView(isBackButton: false, title: "Home", onHistoryButtonPress: {
                    navigateToHistory = true
                })
                
                if !timerDataVM.taskList.isEmpty{
                    //List Content.
                    List(timerDataVM.taskList,id: \.self){ list in
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            timerDataVM.selectedTask = list
                            navigateToTimerView = true
                        }
                    }
                    .background(Color(hex: "#CAF0F8"))
                    .listStyle(.plain)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
                }else{
                    Spacer()
                    Text("No Records Found. Please click '+' Add Task Button to Add New Task.")
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            .background(Color(hex: "#CAF0F8")) // View Background color.
            .overlay(alignment: .bottomTrailing){
                AddTaskButtonView()
            }
        }
        .onAppear {
            timerDataVM.fetchAllTableRecords()
        }
        .navigationDestination(isPresented: $navigateToTimerView) {
            TimerView()
        }
        .navigationDestination(isPresented: $navigateToHistory) {
            HistoryView()
                .navigationBarBackButtonHidden()
        }
        .fullScreenCover(isPresented: $presentAddTaskView) {
            AddTaskView(addTaskView: $presentAddTaskView)
        }
    }
    
    func AddTaskButtonView() -> some View{
        return Button {
            presentAddTaskView = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .padding([.vertical,.horizontal], 20)
    }
}

#Preview {
    HomeView()
}
