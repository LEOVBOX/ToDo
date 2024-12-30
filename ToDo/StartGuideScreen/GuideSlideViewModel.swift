//
//  GuideSlideViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 29.12.2024.
//
import Foundation

class GuideSlideViewModel: ObservableObject {
    var imageName: String = ""
    var descritptionText: String = ""
    
    init(imageName: String, descritptionText: String) {
        self.imageName = imageName
        self.descritptionText = descritptionText
    }
    
}
