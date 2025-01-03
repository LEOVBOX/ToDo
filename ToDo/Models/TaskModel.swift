//
//  TaskModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

struct TaskModel {
    var title: String
    var description: String
    var date: String
    var time: String
    var isCompletd: Bool
    var owner: UserModel
}

var TestTasks = [
    TaskModel(title: "Client meeting", description: "", date: "29-07-24", time: "18:12", isCompletd: false, owner: testUser),
    TaskModel(title: "Team meeting", description: "", date: "20-07-24", time: "20:12", isCompletd: false, owner: testUser),
    TaskModel(title: "Homework", description: "Math homework", date: "29-07-24", time: "20:12", isCompletd: false, owner: testUser),
    TaskModel(title: "Cleaning", description: "Need to clean home", date: "01-07-24", time: "21:12", isCompletd: true, owner: testUser),
]
