//
//  CustomTextField.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 31.12.2024.
//

import SwiftUI

struct CustomTextField: View {
    var image: Image
    @State var placeholder: String
    @Binding var text: String
    @FocusState private var fieldFocused: Bool
    var validate: (String) -> ()
    @State var isSecure: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(height: 42)
                .cornerRadius(5)
            
            HStack (spacing: 10) {
                image
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($fieldFocused)
                        .onSubmit {
                            validate(text)
                        }
                        .disableAutocorrection(true)
                }
                else {
                    TextField(placeholder, text: $text)
                        .focused($fieldFocused)
                        .onSubmit {
                            validate(text)
                        }
                        .disableAutocorrection(true)
                }
                
                
            }
            .padding(.horizontal, 10)
                Spacer()
            }
            
        }
}

