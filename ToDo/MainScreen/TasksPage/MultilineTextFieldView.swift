//
//  MultilineTextFieldView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//
import SwiftUI

struct MultilineTextFieldView: View {
    @Binding var description: String
    
    var image: Image
    var backgroundColor: Color
    var foregroundColor: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            HStack(alignment: .top, spacing: 12){
                Image("description")
                    .resizable()
                    .frame(width: 20, height: 16)
                ZStack(alignment: .topLeading) {
                    
                    
                    TextEditor(text: $description)
                        .scrollContentBackground(.hidden)
                        .background(backgroundColor)
                        .disableAutocorrection(true)
                        .font(Font.custom(mainFontName, size: 16))
                        .foregroundStyle(foregroundColor)
                       
                    if description.isEmpty {
                        Text("description")
                            .font(Font.custom(mainFontName, size: 16))
                            .foregroundColor(foregroundColor)
                    }
                }
            
                Spacer()
            }
            .padding()
            
        }
        
    }
}
