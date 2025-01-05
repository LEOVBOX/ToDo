//
//  TaskModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

struct TaskModel {
    var id: Int
    var title: String
    var description: String
    var date: String
    var time: String
    var isCompleted: Bool
    var owner: UserModel
}

var TestTasks = [
    TaskModel(id: 0, title: "Client meeting", description: "", date: "29-07-24", time: "18:12", isCompleted: false, owner: testUser),
    TaskModel(id: 1, title: "Team meeting", description: "", date: "20-07-24", time: "20:12", isCompleted: false, owner: testUser),
    TaskModel(id: 2, title: "Homework", description: "Math homework", date: "29-07-24", time: "20:12", isCompleted: false, owner: testUser),
    TaskModel(id: 3, title: "Cleaning", description: "Need to clean home", date: "01-07-24", time: "21:12", isCompleted: true, owner: testUser),
]
