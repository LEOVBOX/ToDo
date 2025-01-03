//
//  MainViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var homePageViewModel: HomePageViewModel
    @Published var tasksPageViewModel: TasksPageViewModel
    
    
    init(homePageViewModel: HomePageViewModel, takskPageViewModel: TasksPageViewModel) {
        self.homePageViewModel = homePageViewModel
        self.tasksPageViewModel = takskPageViewModel
    }
}
