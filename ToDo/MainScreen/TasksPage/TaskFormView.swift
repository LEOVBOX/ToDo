//
//  AddTaskView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//

import SwiftUI

struct TaskFormView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    @State var newTaskTitle: String = ""
    @State var descriptionText: String = ""
    @State var date: Date = Date()
    @State var time: Date = Date()
    @FocusState.Binding var newTaskTitleFocused: Bool
    @FocusState.Binding var newTaskDescriptionFocused: Bool
    @State var showDatePicker: Bool = false
    @State var showTimePicker: Bool = false
    @State var selectedTime: Date? = nil
    @State var showAlert: Bool = false
    @State var error: Error? = nil
    @State var confirmButtonText: String
    @State var action: Action
    
    var updateTasks: (() -> Void)? = nil
    
    var closeFunc: () -> Void
    
    var isEditing: Bool {
        return (newTaskTitleFocused || newTaskDescriptionFocused)
    }
    
    enum Action {
        case edit
        case create
    }
    
    func confirm() {
        guard !newTaskTitle.isEmpty, !descriptionText.isEmpty, !viewModel.date.isEmpty, !viewModel.time.isEmpty else {
            showAlert = true
            return
        }
        
        viewModel.title = newTaskTitle
        viewModel.description = descriptionText

        do {
            switch action {
            case .create:
                try viewModel.addTask().get()
            case .edit:
                try viewModel.editTask().get()
            }
            
            updateTasks?()
            closeFunc()
        }
        catch {
            self.error = error
            showAlert = true
        }
    }

    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(.white)
                    .clipShape(.rect(topLeadingRadius: 20, bottomLeadingRadius: isEditing ? 20 : 0, bottomTrailingRadius: isEditing ? 20 : 0, topTrailingRadius: 20))
                    
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }

                VStack {
                    // Task title
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color(0x05243E))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(height: 42)

                            HStack(spacing: 15) {
                                Image("taskTitle")
                                    .resizable()
                                    .frame(width: 16, height: 14)
                                ZStack(alignment: .leading) {
                                    if newTaskTitle.isEmpty {
                                        Text("task")
                                            .font(Font.custom(mainFontName, size: 16))
                                            .foregroundColor(Color(0xFFFFFF, alpha: 0.6))
                                    }

                                    TextField("", text: $newTaskTitle)
                                        .disableAutocorrection(true)
                                        .font(Font.custom(mainFontName, size: 16))
                                        .foregroundStyle(Color(0xFFFFFF, alpha: 0.6))
                                        .focused($newTaskTitleFocused)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                        }
                    }

                    // Description
                    MultilineTextFieldView(description: $descriptionText, image: Image("description"), backgroundColor: Color(0x05243E), foregroundColor: Color(0xFFFFFF, alpha: 0.6))
                        .focused($newTaskDescriptionFocused)

                    // Date and time pickers
                    HStack(spacing: 20) {
                        Button(action: {
                            showDatePicker.toggle()
                            print(dateToString(date))
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(Color(0x05243E))
                                    .frame(height: 42)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))

                                HStack {
                                    Image("date")
                                        .resizable()
                                        .frame(width: 15, height: 14)
                                    Text(!viewModel.date.isEmpty ? viewModel.date : "date")
                                        .font(Font.custom(mainFontName, size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                .padding()
                            }
                        }

                        Button(action: {showTimePicker.toggle()}) {
                            ZStack {
                                Rectangle()
                                    .fill(Color(0x05243E))
                                    .frame(height: 42)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))

                                HStack {
                                    Image("time")
                                        .resizable()
                                        .frame(width: 14, height: 13)
                                    Text(!viewModel.time.isEmpty ? viewModel.time : "time")
                                        .font(Font.custom(mainFontName, size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }

                    // Buttons
                    HStack(spacing: 20) {
                        Button(action: closeFunc) {
                            ZStack {
                                Rectangle()
                                    .stroke(Color(0x0EA5E9), lineWidth: 4)
                                    .frame(height: 45)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))

                                Text("close")
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(.black)
                            }
                        }

                        Button(action: confirm) {
                            ZStack {
                                Rectangle()
                                    .fill(Color(0x0EA5E9))
                                    .frame(height: 45)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))

                                Text(confirmButtonText)
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(.black)
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Ошибка"),
                                message: Text(self.error?.localizedDescription ?? "Cant create task"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }

                    Spacer()
                }
                .padding(.top, 55)
                .padding(.horizontal, 25)
            
            }
            
            .transition(.move(edge: .bottom))
            .blur(radius: showDatePicker ? 10 : 0)
            
            if showDatePicker {
                DatePickerView(date: $date, showDatePicker: $showDatePicker, selectedDate: $viewModel.date)
            }
            
            if showTimePicker {
                TimePickerView(time: $time, showTimePicker: $showTimePicker, selectedTime: $viewModel.time)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        
    }
}

struct DatePickerView: View {
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
            VStack {
                DatePicker("Select a Date", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .transition(.slide) // Анимация появления
                    .padding()
                    
                HStack (spacing: 20) {
                    Button(action: {
                        print(dateToString(date))
                        showDatePicker.toggle()
                        selectedDate = dateToString(date)
                    }) {
                        Text("Ok")
                    }
                    Button(action: {
                        print(dateToString(date))
                        showDatePicker.toggle()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct TimePickerView: View {
    @Binding var time: Date
    @Binding var showTimePicker: Bool
    @Binding var selectedTime: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
            VStack {
                DatePicker("Select a Time", selection: $time, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .transition(.slide)
                    .padding()
                    
                HStack (spacing: 20) {
                    Button(action: {
                        print(timeToString(time))
                        showTimePicker.toggle()
                        selectedTime = timeToString(time)
                    }) {
                        Text("Ok")
                    }
                    Button(action: {
                        print(timeToString(time))
                        showTimePicker.toggle()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}
