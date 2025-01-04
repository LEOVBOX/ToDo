//
//  MainView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 03.01.2025.
//

import SwiftUI

private class CustomTabBarViewModel: ObservableObject {
    @Published var currentIndex: Int
    @Published var tabImages: [String]
    
    init(currentIndex: Int, tabImages: [String]) {
        self.currentIndex = currentIndex
        self.tabImages = tabImages
    }
}


private struct CustomTabBarView: View {
    @ObservedObject var viewModel: CustomTabBarViewModel
    
    var body: some View {
        HStack(spacing: 70) {
            ForEach(viewModel.tabImages.indices, id: \.self) { index in
                Button(action: {
                    viewModel.currentIndex = index
                }) {
                    Image(viewModel.tabImages[index])
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .shadow(color: viewModel.currentIndex == index ? Color(0x76D5EA, alpha: 0.25): .clear, radius: 4, y: 4)
                    
                }
                .tint(viewModel.currentIndex == index ? Color(0x76D5EA) : .white)
            }
        }
    }
}


struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @StateObject private var tabBarViewModel = CustomTabBarViewModel(
        currentIndex: 0,
        tabImages: ["home", "tasks", "calendar", "settings"]
    )
    
    @State var showTabBar = true
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $tabBarViewModel.currentIndex) {
                    HomeView(viewModel: viewModel.homePageViewModel)
                        .tag(0)
                    TasksView(viewModel: viewModel.tasksPageViewModel, showTabBar: $showTabBar)
                        .tag(1)
                    SettingsView()
                        .tag(3)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
                if showTabBar {
                    CustomTabBarView(viewModel: tabBarViewModel)
                }
                
            }
            .ignoresSafeArea()
            .padding(.bottom, showTabBar ? 20 : 0)
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(homePageViewModel: HomePageViewModel(user: testUser, tasks: TestTasks), takskPageViewModel: TasksPageViewModel(user: testUser, tasks: TestTasks)))
}
