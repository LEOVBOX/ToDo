//
//  HomeView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import SwiftUI

struct TaskLabelView: View {
    @State var viewModel: TaskViewModel
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(height: 50)
                .cornerRadius(5)
            
            VStack {
                HStack {
                    if viewModel.isCompletd {
                        Image("completedMark")
                    }
                    
                    VStack {
                        HStack {
                            Text(viewModel.title)
                                .font(Font.custom(mainFontName, size: 14))
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        HStack {
                            Text(viewModel.date + " | " + viewModel.time)
                                .font(Font.custom(mainFontName, size: 10))
                                .foregroundStyle(Color(0x000000, alpha: 0.9))
                            Spacer()
                        }
                        
                    }
                    
                    Spacer()
                    
                    Button (action:  {
                        
                    })
                    {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 12, height: 16)
                            .tint(Color(0x0EA5E9))
                    }
                    
                }
                .padding()
            }
        }
    }
}

struct HomeView: View {
    private let backgroundGradient = LinearGradient(gradient: Gradient(colors: [Color(0x1254AA), Color(0x05243E)]), startPoint: .top, endPoint: .bottom)
    var viewModel: HomePageViewModel
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .onTapGesture {
                    //focusedField = nil
                }
            
            VStack(spacing: 70) {
                // User info
                HStack {
                    VStack (alignment: .leading) {
                        Text(viewModel.user.name)
                            .font(Font.custom(mainFontName, size: 18))
                            .foregroundStyle(.white)
                        Text(viewModel.user.email)
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(Color(0xFFFFFF, alpha: 0.5))
                        
                    }
                    Spacer()
                }
                
                // Tasks
                VStack (spacing: 25) {
                    HStack {
                        Text("Incomplete Tasks")
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    
                    VStack {
                        if let tasks = viewModel.tasks {
                            ForEach(tasks.indices, id: \.self) { index in
                                TaskLabelView(viewModel: tasks[index])
                            }
                        }
                    }
                    
                    HStack {
                        Text("Completed Tasks")
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                
                
                Spacer()
                
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
        }
    }
}

#Preview {
    HomeView(viewModel: HomePageViewModel(user: UserModel(id: 0, name: "User", email: "User1@mail.ru"), tasks: [
        TaskViewModel(title: "Client meeting", description: "", date: "20-07-24", time: "18:12", isCompletd: false),
        TaskViewModel(title: "Client meeting", description: "", date: "20-07-24", time: "18:12", isCompletd: false),
    ]))
}
