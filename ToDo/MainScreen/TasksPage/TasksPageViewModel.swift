//
//  TasksPageViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

import Foundation

class TasksPageViewModel: ObservableObject {
    var user: UserModel
    var alertCallback: ((Error) -> ())?
    private var tasks: [TaskViewModel] = []
    @Published var showTasks: [TaskViewModel] = []
    @Published var showAddTaskView = false
    let databaseManager: DatabaseManager

    init(user: UserModel, databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
        self.user = user
        fetchTasks()
        
    }
    
    // TODO: удалить этот инициализатор
    
    init(user: UserModel, tasks: [TaskModel]) {
        self.user = user
        self.databaseManager = SQLiteManager.shared
        for task in tasks {
            let viewModel = TaskViewModel(task: task)
            self.tasks.append(viewModel)
            if !viewModel.isCompleted {
                showTasks.append(viewModel)
            }
        }
    }
    
    func filterTasks(name: String) {
        if !name.isEmpty {
            showTasks = tasks.filter { $0.title.localizedCaseInsensitiveContains(name) }
        }
        else {
            showTasks = tasks.filter { !$0.isCompleted }
        }
    }

    func fetchTasks() {
        // Получение задач из базы данных
        do {
            let fetchedTasks = try databaseManager.getTasksForUser(user: user, count: nil, isCompleted: false).get()
            for task in fetchedTasks {
                let viewModel = TaskViewModel(task: task)
                tasks.append(viewModel)
                if !viewModel.isCompleted {
                    showTasks.append(viewModel)
                }
            }
        }
        catch {
            alertCallback?(error)
        }
    }

    func addTask(title: String, description: String, date: String, time: String) {
        // Создание новой задачи в базе данных
        let newTask = TaskModel(title: title, description: description, date: date, time: time, isCompletd: false, owner: user)
        databaseManager.addTask(task: newTask)
        
        // Обновление массива задач
        fetchTasks()
    }
}
