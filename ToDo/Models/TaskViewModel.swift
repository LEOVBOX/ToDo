//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//
import Foundation

class TaskViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var date: String
    @Published var time: String
    @Published var isCompleted: Bool
    
    init(task: TaskModel) {
        self.title = task.title
        self.description = task.description
        self.date = task.date
        self.time = task.time
        self.isCompleted = task.isCompletd
    }
}
