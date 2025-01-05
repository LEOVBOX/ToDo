//
//  AddTaskViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//
import Foundation

func dateToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current
    return formatter.string(from: date)
}

func timeToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let result = formatter.string(from: date)
    return result
}

class TaskViewModel: ObservableObject {
    @Published var user: UserModel
    var databaseManager: DatabaseManager
    
    @Published var title: String
    @Published var description: String
    @Published var date: String
    @Published var time: String
    @Published var isCompleted: Bool
    @Published var id: Int? = nil
    
    
    init(task: TaskModel, databaseManager: DatabaseManager) {
        self.title = task.title
        self.description = task.description
        self.date = task.date
        self.time = task.time
        self.isCompleted = task.isCompleted
        self.id = task.id
        self.user = task.owner
        self.databaseManager = databaseManager
    }
    
    init(user: UserModel, databaseManager: DatabaseManager) {
        self.title = ""
        self.description = ""
        self.date = ""
        self.isCompleted = false
        self.time = ""
        self.user = user
        self.databaseManager = databaseManager
    }
    
    
    func addTask() -> Result<Void, Error> {
        do {
            try databaseManager.addTask(title: title, description: description, date: date, time: time, isCompletd: false, owner: user).get()
        }
        
        catch {
            return .failure(error)
        }
        
        return .success(())
    }
    
    func deleteTask() -> Result<Void, Error> {
        guard let id = id else {
            return .failure(NSError(domain: "No id", code: 2))
        }
        do {
            try databaseManager.deleteTask(id: id).get()
        }
        catch {
            return .failure(error)
        }
        
        return .success(())
    }
    
    func editTask() -> Result<Void, Error> {
        guard let id = id else {
            return .failure(NSError(domain: "No id", code: 2))
        }
        do {
            try databaseManager.editTask(task: TaskModel(id: id, title: title, description: description, date: date, time: time, isCompleted: isCompleted, owner: user)).get()
        }
        catch {
            return .failure(error)
        }
        return .success(())
    }
}
