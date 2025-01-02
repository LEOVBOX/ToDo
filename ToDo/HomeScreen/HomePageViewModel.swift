//
//  HomePageViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import Foundation



class HomePageViewModel: ObservableObject {
    @Published var user: UserModel
    @Published var tasks: [TaskViewModel]?
    
    func fetchTasks(userId: Int) {
        do {
            tasks = try SQLiteManager.shared.getTasksForUser(userId: userId).get()
        }
        catch {
            print(error)
        }
    }
    
    init(user: UserModel, tasks: [TaskViewModel]) {
        self.user = user
        self.tasks = tasks
    }
    
    init(user: UserModel) {
        self.user = user
        fetchTasks(userId: user.id)
    }
}
