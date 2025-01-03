//
//  StartSceenView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 18.12.2024.
//

import SwiftUI

struct CustomTabIndicator: View {
    @Binding var currentIndex: Int
    @State var tabCount: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                switch index {
                // first
                case 0:
                    Capsule()
                        .frame(width: currentIndex == 0 ? 45 : 20, height: 6)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    
                // last
                case 2:
                    Capsule()
                        .frame(width: currentIndex == tabCount - 1 ? 45 : 20, height: 6)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    
                // middle
                default:
                    Capsule()
                        .frame(width: (currentIndex > 0 && currentIndex < tabCount - 1) ? 45 : 20, height: 6)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                }
            }
            
        }
    }
}

struct GuideView: View {
    @State var currentIndex = 0
    @StateObject var viewModel = GuideViewModel(slidesViewModels: [
        GuideSlideViewModel(imageName: "illustration1", descritptionText: "Plan your tasks to do, that way you’ll stay organized and you won’t skip any"),
        GuideSlideViewModel(imageName: "illustration2", descritptionText: "Make a full schedule for the whole week and stay organized and productive all days"),
        GuideSlideViewModel(imageName: "illustration3", descritptionText: "create a team task, invite people and manage your work together"),
        GuideSlideViewModel(imageName: "illustration4", descritptionText: "You informations are secure with us"),
    ])
    
    @State private var showSignInView = false
    
    let backgroundGradient = LinearGradient(gradient: Gradient(colors: [Color(0x1254AA), Color(0x05243E)]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack {
                TabView(selection: $currentIndex){
                    ForEach(viewModel.slidesViewModels.indices, id: \.self) { index in
                        GuideSlideView(viewModel: viewModel.slidesViewModels[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack (alignment: .center, spacing: 60) {
                    
                    CustomTabIndicator(currentIndex: $currentIndex, tabCount: viewModel.slidesViewModels.count)
                    
                    Button(action: {
                        if currentIndex < viewModel.slidesViewModels.count - 1 {
                            currentIndex += 1
                        } else {
                            UserDefaultsManager.shared.skipGuide(skipGuide: true)
                            showSignInView = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 70, height: 70)
                                .foregroundStyle(.white)
                                .shadow(color: .white, radius: 5, x: 0, y: 4)
                            Image(systemName: currentIndex == viewModel.slidesViewModels.count - 1 ? "checkmark" : "arrow.right")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .tint(.black)
                        }
                    }
                    .fullScreenCover(isPresented: $showSignInView) {
                        SignUpView()
                    }
                }
                .padding(.leading, 160)
                .padding(.trailing, 50)
            }
            .padding(.bottom, 60)
        }
    }
        
}

struct GuideSlideView: View {
    @StateObject var viewModel: GuideSlideViewModel
    
    var body: some View {
        VStack (spacing: 100) {
                Image(viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                
                Text(viewModel.descritptionText)
                    .foregroundStyle(.white)
                    //.font(.system(size: 20))
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .multilineTextAlignment(.center)
                    .bold()
                Spacer()
                
            }
            .padding(.horizontal, 70)
            .padding(.top, 100)
    }
}

#Preview {
    GuideView()
}
