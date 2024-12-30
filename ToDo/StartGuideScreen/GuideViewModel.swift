//
//  GuideViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 29.12.2024.
//

import Foundation

class GuideViewModel: ObservableObject {
    var slidesViewModels: [GuideSlideViewModel] = []
    
    init(slidesViewModels: [GuideSlideViewModel]) {
        self.slidesViewModels = slidesViewModels
    }
}
