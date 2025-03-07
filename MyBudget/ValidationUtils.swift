//
//  ValidationUtils.swift
//  MyBudget
//
//  Created by Katya Durneva Svedmark on 2024-12-01.
//


import Foundation

struct ValidationUtils {
    
    // Validate email format
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Validate password strength (e.g., minimum 6 characters)
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    // Check if a field is empty
    static func isNotEmpty(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func validateEmail(email: String) -> String? {
        if !isNotEmpty(email) {
            return String(localized:"Email field cannot be empty.")
        } else if !isValidEmail(email) {
            return String(localized: "Invalid email format.")
        }
        return nil
    }
    
    static func validatePassword(password: String) -> String? {
        if !isNotEmpty(password) {
            return String(localized: "Password field cannot be empty.")
        } else if !isValidPassword(password) {
            return String(localized: "Password must be 6+ characters.")
        }
        return nil
    }
    
    static func validateConfirmPassword(password: String, confirmPassword: String) -> String? {
        if !isNotEmpty(password) {
            return String(localized: "Password field cannot be empty.")
        } else if password != confirmPassword {
            return String(localized: "Passwords do not match.")
        }
        return nil
    }
    
    static func validateReset(email: String) -> String? {
        if !isNotEmpty(email) {
            return String(localized: "Email field cannot be empty.")
        } else if !isValidEmail(email) {
            return String(localized: "Invalid email format.")
        }
        return nil
    }
}
