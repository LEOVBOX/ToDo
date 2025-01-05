//
//  HomePageViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import Foundation



class HomePageViewModel: ObservableObject {
    var user: UserModel
    let databaseManager: DatabaseManager
    @Published var tasks: [TaskViewModel] = []
    
    func fetchTasks() {
        do {
            let completedTasks = try databaseManager.getTasksForUser(user: user, count: 2, isCompleted: true).get()
            tasks = []
            for task in completedTasks {
                tasks.append(TaskViewModel(task: task, databaseManager: SQLiteManager.shared))
            }
            let uncompletedTasks = try databaseManager.getTasksForUser(user: user, count: 2, isCompleted: false).get()
            for task in uncompletedTasks {
                tasks.append(TaskViewModel(task: task, databaseManager: SQLiteManager.shared))
            }
        }
        catch {
            print(error)
        }
    }
    
    init(user: UserModel, databaseManager: DatabaseManager) {
        self.user = user
        self.databaseManager = databaseManager
        fetchTasks()
    }
    
    // TODO: Убрать этот инициализатор
    
    init(user: UserModel, tasks: [TaskModel]) {
        self.user = user
        self.databaseManager = SQLiteManager.shared
        for task in tasks {
            self.tasks.append(TaskViewModel(task: task, databaseManager: SQLiteManager.shared))
        }
    }
}
