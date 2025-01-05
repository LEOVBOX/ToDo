//
//  TaskView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 05.01.2025.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State var showPrevView = false
    @FocusState.Binding var newTaskTitleFocused: Bool
    @FocusState.Binding var descriptionFocused: Bool
    //@Binding var showTabBar: Bool
    @State var showTaskForm: Bool = false
    @State var showAlert: Bool = false
    @State var alertError: Error? = nil
    
    @State var close: () -> ()
    
    func closeTaskForm() {
        showTaskForm = false
        //showTabBar = true
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack (spacing: 40) {
                HStack (spacing: 15){
                    Button (action: {
                        close()
                    }){
                        Image("chevronLeft")
                            .resizable()
                            .frame(width: 10, height: 18)
                    }
                    
                    
                    Text("Task Details")
                        .foregroundStyle(.white)
                        .font(Font.custom(mainFontName, size: 16))
                    Spacer()
                }
                
                VStack (alignment: .leading, spacing: 25) {
                    // Task title
                    VStack (alignment: .leading) {
                        HStack (spacing: 10) {
                            Text(viewModel.title)
                                .font(Font.custom(mainFontName, size: 18))
                                .foregroundStyle(.white)
                            
                            Button (action: {
                                showTaskForm = true
                            }) {
                                Image("edit")
                                    .resizable()
                                    .frame(width: 20, height: 16)
                            }
                            Spacer()
                            
                        }
                        
                        HStack {
                            Image("calendar")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(viewModel.date)
                                .font(Font.custom(mainFontName, size: 14))
                                .foregroundStyle(.white)
                            Text("|")
                                .font(Font.custom(mainFontName, size: 14))
                                .foregroundStyle(.white)
                            
                            Image("time")
                                .resizable()
                                .frame(width: 11, height: 11)
                            Text(viewModel.time)
                                .font(Font.custom(mainFontName, size: 14))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray)
                    
                    ScrollView {
                        Text(viewModel.description)
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(.white)
                    }
                    
                }
                
                HStack (spacing: 72) {
                    Button (action: {
                        viewModel.isCompleted = true
                        viewModel.editTask()
                        close()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 88, height: 70)
                                .foregroundStyle(Color(0x05243E))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: Color(0xFFFFFF, alpha: 0.25), radius: 5)
                                
                            VStack {
                                Image("done")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                
                                Text("Done")
                                    .font(Font.custom(mainFontName, size: 14))
                                    .foregroundStyle(.white)
                                
                            }
                        }
                    }
                    
                    Button (action: {
                        do {
                            try viewModel.deleteTask().get()
                            close()
                        }
                        catch {
                            showAlert = true
                            alertError = error
                        }
                        
                        
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 88, height: 70)
                                .foregroundStyle(Color(0x05243E))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: Color(0xFFFFFF, alpha: 0.25), radius: 5)
                                
                            VStack {
                                Image("delete")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                
                                Text("Delete")
                                    .font(Font.custom(mainFontName, size: 14))
                                    .foregroundStyle(.white)
                                
                            }
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Ошибка"),
                            message: Text(alertError?.localizedDescription ?? "Неизвестная ошибка"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
                Spacer()
            }
            .blur(radius: showTaskForm ? 10 : 0)
            .padding(.top, 30)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
            
            if showTaskForm {
                VStack {
                    if (!newTaskTitleFocused && !descriptionFocused) {
                        Spacer()
                    }
                    
                    TaskFormView(viewModel: viewModel, newTaskTitle: viewModel.title, descriptionText: viewModel.description, newTaskTitleFocused: $newTaskTitleFocused, newTaskDescriptionFocused: $descriptionFocused, confirmButtonText: "save", action: .edit, closeFunc: closeTaskForm)
                    
                    if (newTaskTitleFocused || descriptionFocused) {
                        Spacer()
                    }
                }
            }
        }
    }
}


