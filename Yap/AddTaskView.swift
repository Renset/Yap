//
//  AddTaskView.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import SwiftUI

struct AddTaskView : View {
    
    @State var titleText : String = ""
    @State var descriptionText : String = ""
    @FocusState var isTextFieldFocused : Bool
    @FocusState var isTextEditorFocused : Bool
    @Binding var addTaskView            : Bool
    @State private var isShowingPicker = false
    @EnvironmentObject var timerDataVM : TimerDataViewModel
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedSecond = 0
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack(spacing: 14){
                GlobalHeaderView(isBackButton: true, title: "Add Task",isAddTaskView: true,onDismiss:{
                    addTaskView = false
                })
                
                VStack(alignment: .leading,spacing: 12){
                    Text("Title")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black)
                    TextField("", text: $titleText,prompt: Text("Enter your title here...")
                        .foregroundColor(Color(hex: "#9e9e9e"))
                        .kerning(0.2)
                    )
                    .frame(height: 50)
                    .font(.system(size: 18))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
                    .focused($isTextFieldFocused)
                    .background(Color.white)
                    .contentShape(Rectangle())
                    .submitLabel(.done)
                    .padding(2)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                            .frame(height: 50)
                    }
                    .onChange(of: titleText) { newValue in
                        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmed.count > 90 {
                            titleText = String(trimmed.prefix(90))
                        }
                    }
                    .onSubmit {
                        isTextEditorFocused = true
                    }
                    .onTapGesture {
                        isShowingPicker = false
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                
                VStack(alignment: .leading,spacing: 12) {
                    Text("Description")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black)
                    TextEditor(text: $descriptionText)
                        .font(.system(size: 18))
                        .focused($isTextEditorFocused)
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .textInputAutocapitalization(.sentences)
                        .scrollContentBackground(.hidden)
                        .multilineTextAlignment(.leading)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(height: 90, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .padding(.horizontal, 20)
                timePickerTextField()
                Spacer()
                saveDataButton()
            }
            .ignoresSafeArea()
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            .background(Color(hex: "#CAF0F8")) // View Background color.
        }
        .onAppear {
            isTextFieldFocused = true
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        isTextEditorFocused = false
                    }
                }
            }
        }
    }
    
    /// Creates a custom text field that displays a time picker when tapped.
    /// The text field shows the selected time in `HH:MM:SS` format only if it's not "00:00:00".
    /// Otherwise, it remains empty.
    ///
    /// - Returns: A SwiftUI `View` containing the text field with an overlay clock icon.
    func timePickerTextField() -> some View{
        VStack(alignment: .leading,spacing: 12) {
            Text("Duration")
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
            
            TextField("",text: .constant((selectedHour != 0 || selectedMinute != 0 || selectedSecond != 0) ?
                                         String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond) : ""))
            .padding()
            .frame(height: 50)
            .foregroundStyle(Color.black)
            .background(Color.white)
            .cornerRadius(8)
            .tint(Color.clear)
            .allowsHitTesting(false)
            .overlay(
                ZStack {
                    // Border
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                    
                    // Clock icon on the right
                    HStack {
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                }
                    .contentShape(Rectangle()) // Ensures the whole area is tappable
                    .onTapGesture {
                        isTextFieldFocused = false
                        isTextEditorFocused = false
                        isShowingPicker.toggle()
                    }
            )
            
            // Time Picker Modal with Done Button
            if isShowingPicker {
                VStack(spacing: 0) {
                    // Done Button at the Top
                    HStack {
                        Spacer()
                        Button("Done") {
                            isShowingPicker = false
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        // Hour Picker
                        Picker("", selection: $selectedHour) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour)").tag(hour)
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 150)
                        
                        // Minute Picker
                        Picker("", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute)").tag(minute)
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 150)
                        
                        // Second Picker
                        Picker("", selection: $selectedSecond) {
                            ForEach(0..<60, id: \.self) { second in
                                Text("\(second)").tag(second)
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 150)
                    }
                    
                }
                .padding(.bottom, 10)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
        }
        .padding(.horizontal, 20)
    }
    
    /// This function creates a "Save" button to allow the user to mark they are ready to proceed.
    /// It updates the `isGetStarted` flag to true in UserDefaults when pressed.
    /// - Returns: A Button view configured with the "Get Started" label and style.
    func saveDataButton() -> some View{
        return Button {
            timerDataVM.createOrUpdateTask(id: UUID().uuidString, title: titleText.trimmingCharacters(in: .newlines), description: descriptionText, duration: String(format: "%02d:%02d:%02d", selectedHour, selectedMinute, selectedSecond))
            addTaskView = false
        } label: {
            ZStack{
                Capsule()
                    .foregroundStyle(Color(hex: "#5154ff"))
                
                Text("Save")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
        .frame(height: 50)
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, 25)
        .disabled(titleText.isEmpty || descriptionText.isEmpty || (selectedHour == 0 && selectedMinute == 0 && selectedSecond == 0))
    }
    
    // Format Date to HH:mm:ss
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
