//
//  DatabaseManager.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

protocol DatabaseManager {
    func addUser(name: String, email: String) -> Result<Int, Error>
    func getUser(id: Int) -> Result<UserModel, Error>
    func getUser(login: String) -> Result<UserModel, Error>
    func getTasksForUser(user: UserModel, count: Int?, isCompleted: Bool?) -> Result<[TaskModel], Error>
    func deleteTask(id: Int) -> Result<Void, Error>
    func addTask(title: String, description: String, date: String, time: String, isCompletd: Bool, owner: UserModel) -> Result<Int, Error>
    func editTask(task: TaskModel) -> Result<Void, Error>
}
