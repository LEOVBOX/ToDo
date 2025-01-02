//
//  StorageManager.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import SQLite3
import Foundation

class SQLiteManager {
    static let shared = SQLiteManager()
    
    private var dbFilePath: URL?
    
    private var db: OpaquePointer?
    init() {
        openDatabase()
    }
    
    // Открыть или создать базу данных
    private func openDatabase() {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("ToDo.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            dbFilePath = fileURL
            sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)
            createTables()
        } else {
            print("Не удалось открыть базу данных")
        }
    }
    
    private func createTables() {
        let createUsersTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
        Id INTEGER PRIMARY KEY, 
        Name TEXT NOT NULL,
        Email TEXT NOT NULL UNIQUE
        );
        """
        
        if sqlite3_exec(db, createUsersTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error of creating or opening Users table: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        let createTasksTableQuery = """
        CREATE TABLE IF NOT EXISTS Tasks (Id INTEGER PRIMARY KEY,
        Title TEXT NOT NULL,
        Description TEXT,
        Date DATE,
        Time TEXT, -- Время в формате HH:MM:SS
        Status INTEGER NOT NULL,
        UserID INTEGER,
        FOREIGN KEY (UserID) REFERENCES Users(Id) ON DELETE CASCADE
        );
        """
        
        if sqlite3_exec(db, createTasksTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error of creating or opening Tasks table: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    func addUser(name: String, email: String) -> Result<Int, Error> {
        let insertUserQuery = """
        INSERT INTO Users (Name, Email) VALUES (?, ?);
        """
        
        var statement: OpaquePointer?
        
        // Подготовка SQL-запроса
        if sqlite3_prepare_v2(db, insertUserQuery, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            return .failure(NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement: \(errorMessage)"]))
        }
        
        // Привязка параметров
        sqlite3_bind_text(statement, 1, name, -1, nil)
        sqlite3_bind_text(statement, 2, email, -1, nil)
        
        // Выполнение SQL-запроса
        if sqlite3_step(statement) == SQLITE_DONE {
            // Получение последнего добавленного ID
            let lastInsertedId = sqlite3_last_insert_rowid(db)
            sqlite3_finalize(statement)
            return .success(Int(lastInsertedId))
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            sqlite3_finalize(statement)
            return .failure(NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to insert user: \(errorMessage)"]))
        }
    }

    
    func getUser(id: Int) -> Result<UserModel, Error> {
        let selectUserQuery = """
        SELECT Id, Name, Email FROM Users WHERE Id = ?;
        """
        
        var statement: OpaquePointer?
        
        // Подготовка SQL-запроса
        if sqlite3_prepare_v2(db, selectUserQuery, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            return .failure(NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement: \(errorMessage)"]))
        }
        
        // Привязка параметра
        sqlite3_bind_int(statement, 1, Int32(id))
        
        // Выполнение SQL-запроса
        if sqlite3_step(statement) == SQLITE_ROW {
            // Извлечение данных
            guard
                let namePointer = sqlite3_column_text(statement, 1),
                let emailPointer = sqlite3_column_text(statement, 2)
            else {
                sqlite3_finalize(statement)
                return .failure(NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user data"]))
            }
            
            let userId = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: namePointer)
            let email = String(cString: emailPointer)
            
            sqlite3_finalize(statement)
            return .success(UserModel(id: userId, name: name, email: email))
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            sqlite3_finalize(statement)
            return .failure(NSError(domain: "SQLiteError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to find user: \(errorMessage)"]))
        }
    }
    
    func getUser(login: String) -> Result<UserModel, Error> {
        let formatedLogin = "'\(login)'"
        let selectUserQuery = """
        SELECT Id, Name, Email FROM Users WHERE Email = \(formatedLogin);
        """
        
        var statement: OpaquePointer?
        
        // Подготовка SQL-запроса
        if sqlite3_prepare_v2(db, selectUserQuery, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            return .failure(NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement: \(errorMessage)"]))
        }
        
        
        // Выполнение SQL-запроса
        if sqlite3_step(statement) == SQLITE_ROW {
            // Извлечение данных
            guard
                let namePointer = sqlite3_column_text(statement, 1),
                let emailPointer = sqlite3_column_text(statement, 2)
            else {
                sqlite3_finalize(statement)
                return .failure(NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user data"]))
            }
            
            let userId = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: namePointer)
            let email = String(cString: emailPointer)
            
            sqlite3_finalize(statement)
            return .success(UserModel(id: userId, name: name, email: email))
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            sqlite3_finalize(statement)
            return .failure(NSError(domain: "SQLiteError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to find user: \(errorMessage)"]))
        }
    }
    
    func getTasksForUser(userId: Int) -> Result<[TaskViewModel], Error> {
        let selectTasksQuery = """
        SELECT Title, Description, Date, Time, Status
        FROM Tasks 
        WHERE UserID = ?;
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, selectTasksQuery, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            return .failure(NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement: \(errorMessage)"]))
        }
        
        sqlite3_bind_int(statement, 1, Int32(userId))

        var tasks: [TaskViewModel] = []

        while sqlite3_step(statement) == SQLITE_ROW {
            guard
                let titlePointer = sqlite3_column_text(statement, 0),
                let datePointer = sqlite3_column_text(statement, 2),
                let timePointer = sqlite3_column_text(statement, 3)
            else {
                sqlite3_finalize(statement)
                return .failure(NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve task data"]))
            }

            let title = String(cString: titlePointer)
            let description = sqlite3_column_text(statement, 1).flatMap { String(cString: $0) } ?? ""
            let date = String(cString: datePointer)
            let time = String(cString: timePointer)
            let status = Int(sqlite3_column_int(statement, 4)) == 1 ? true : false

            let task = TaskViewModel(title: title, description: description, date: date, time: time, isCompletd: status)
            tasks.append(task)
        }

        sqlite3_finalize(statement)

        return .success(tasks)
    }


    
    /* TODO: Написать методы
     1. Добавления нового пользователя +
     2. Добавления новой таски
     3. Получения списка пользователей
     4. Получения списка тасок для определенного пользователя +
     5. Удаления пользователя
     6. Удаления таски
     7. Обновления информации по таске
     */
}
