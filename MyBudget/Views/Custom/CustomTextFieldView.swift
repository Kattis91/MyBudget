//
//  CustomTextFieldView.swift
//  MyBudget
//
//  Created by Katya Durneva Svedmark on 2024-12-03.
//

import SwiftUI

struct CustomTextFieldView: View {
    
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var onChange: (() -> Void)? = nil
    var leadingPadding: CGFloat = 24
    var trailingPadding: CGFloat = 24
    var systemName: String?
    var forget: Bool = false
    var maxLength: Int? = nil
    
    @Environment(\.colorScheme) var colorScheme
    var isDarkMode: Bool {
        return colorScheme == .dark
    }
    
    var body: some View {
        HStack {
            // Add the icon
            Image(systemName: systemName ?? "")
                .foregroundColor(isDarkMode ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                .padding(.horizontal, 5)
                .scaledToFit()
                .frame(width: 20, height: 20)
            
            // Conditionally render SecureField or TextField
            if isSecure {
                SecureField("", text: $text, prompt: isDarkMode ? Text(placeholder).foregroundStyle(.white.opacity(0.8)) : Text(placeholder).foregroundStyle(.black.opacity(0.5)))
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .tint(isDarkMode ? .white : .black)
                    .onChange(of: text) { oldValue, newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                        onChange?()
                    }
            } else {
                TextField("", text: $text, prompt: isDarkMode ? Text(placeholder).foregroundStyle(.white.opacity(0.8)) : Text(placeholder).foregroundStyle(.black.opacity(0.5)))
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .tint(isDarkMode ? .white : .black)
                    .onChange(of: text) { oldValue, newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                        onChange?()
                    }
            }
        }
        .frame(height: 41)
        .textFieldStyle(PlainTextFieldStyle())
        .padding(.horizontal)
        .background(
            LinearGradient(
                gradient: Gradient(colors: isDarkMode ?
                    [.inputGradientLight, .inputGradientDark] :
                    [.backgroundTintLight, .backgroundTintDark]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.4), radius: 4, x: -3, y: 4)
        // Add subtle border for more definition
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
        )
        .padding(.leading, leadingPadding)
        .padding(.trailing, trailingPadding)
        .padding(.bottom, 6)
        .onChange(of: text) {
            onChange?()
        }
    }
}

#Preview {
    @Previewable @State var email = ""
    @Previewable @State var password = ""
    CustomTextFieldView(placeholder: "Email", text: $email, isSecure: false, onChange: {  }, systemName: "envelope")
}
