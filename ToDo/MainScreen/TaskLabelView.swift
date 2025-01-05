//
//  TaskLabelView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

import SwiftUI

struct TaskLabelView: View {
    @ObservedObject var viewModel: TaskViewModel
    var showTaskView: (TaskViewModel)->()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(height: 50)
                .cornerRadius(5)
            
            VStack {
                HStack {
                    if viewModel.isCompleted {
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
                        showTaskView(viewModel)
                    })
                    {
                        Image("chevronRight")
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
