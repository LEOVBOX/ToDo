//
//  HomeView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomePageViewModel
    @State var isShowTaskView = false
    @State var taskViewModel: TaskViewModel?
    @FocusState var taskFormTitleFocused: Bool
    @FocusState var taskFormDescriptionFocused: Bool
    
    func showTaskView(viewModel: TaskViewModel) {
        taskViewModel = viewModel
        isShowTaskView = true
    }
    
    func closeTaskView() {
        isShowTaskView = false
        viewModel.fetchTasks()
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                        ForEach(viewModel.tasks.indices, id: \.self) { index in
                            if !viewModel.tasks[index].isCompleted {
                                TaskLabelView(viewModel: viewModel.tasks[index], showTaskView: showTaskView)
                            }
                            
                        }
                    }
                    
                    HStack {
                        Text("Completed Tasks")
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    
                    VStack {
                        
                        ForEach(viewModel.tasks.indices, id: \.self) { index in
                            if viewModel.tasks[index].isCompleted {
                                TaskLabelView(viewModel: viewModel.tasks[index], showTaskView: showTaskView)
                            }
                        }
                    }
                }
                
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            
            
            if isShowTaskView, let taskViewModel = taskViewModel {
                TaskView(viewModel: taskViewModel, newTaskTitleFocused: $taskFormTitleFocused, descriptionFocused: $taskFormDescriptionFocused, close: closeTaskView)
            }
        }
        .onAppear {
            viewModel.fetchTasks()
        }
    }
}


#Preview {
    HomeView(viewModel: HomePageViewModel(user: testUser, tasks: TestTasks))
}
