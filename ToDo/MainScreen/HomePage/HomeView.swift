//
//  HomeView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import SwiftUI

struct HomeView: View {
    var viewModel: HomePageViewModel
    var body: some View {
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
                            TaskLabelView(viewModel: viewModel.tasks[index])
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
                            TaskLabelView(viewModel: viewModel.tasks[index])
                        }
                    }
                }
            }
            
            
            Spacer()
            
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
    }
}


#Preview {
    HomeView(viewModel: HomePageViewModel(user: testUser, tasks: TestTasks))
}
