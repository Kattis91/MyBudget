//
//  CustomSettingsMenu.swift
//  MyBudget
//
//  Created by Katya Durneva Svedmark on 2025-01-10.
//

import SwiftUI

struct CustomSettingsMenu: View {
    var budgetfb: BudgetFB
    var onCategoriesUpdate: () async -> Void
    @State private var showPopover = false
    @State var showCategoryManagement = false
    @State private var showInvoiceReminders = false
    @State var showDeleteAccount = false
    @State private var selectedItem: Int? = nil
    
    @Environment(\.colorScheme) var colorScheme
    var isDarkMode: Bool {
        return colorScheme == .dark
    }
    
    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color("PrimaryTextColor"))
        }
        .popover(isPresented: $showPopover, attachmentAnchor: .point(.bottom)) {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedItem = 0
                    }
                    showPopover = false
                    showCategoryManagement = true
                }) {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: 24)
                            .foregroundColor(Color("CustomGreen"))
                        Text("Manage Categories")
                            .foregroundColor(Color("PrimaryTextColor"))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                
                Divider()
                    .background(Color.gray.opacity(0.4))
                
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedItem = 1
                    }
                    showPopover = false
                    showInvoiceReminders = true
                }) {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.orange)
                        Text("Invoice Reminders")
                            .foregroundColor(Color("PrimaryTextColor"))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                
                Divider()
                    .background(Color.gray.opacity(0.4))
                
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedItem = 2
                    }
                    showPopover = false
                    showDeleteAccount = true
                }) {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.minus")
                            .frame(width: 24)
                            .foregroundColor(Color("ButtonsBackground"))
                        Text("Delete account")
                            .foregroundColor(Color("PrimaryTextColor"))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode ?
                        [Color(.darkGray), Color(.black)] : [
                        Color(red: 245/255, green: 247/255, blue: 245/255),
                        Color(red: 240/255, green: 242/255, blue: 240/255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .shadow(
                color: isDarkMode ? Color.black.opacity(0.35) : Color.black.opacity(0.15),
                radius: isDarkMode ? 2 : 4,
                x: isDarkMode ? -2 : 0,
                y: isDarkMode ? 4 : 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isDarkMode ? Color.white.opacity(0.2) :
                                Color.white.opacity(0.4), lineWidth: 0.8)
            )
            .presentationCompactAdaptation(.popover)
        }
        .sheet(isPresented: $showCategoryManagement) {
            CategoryManagementView(
                budgetfb: budgetfb,
                onCategoriesUpdate: onCategoriesUpdate
            )
        }
        .sheet(isPresented: $showInvoiceReminders) {
            InvoiceReminderView()
        }
        .sheet(isPresented: $showDeleteAccount) {
            DeleteAccountView()
        }
    }
}

#Preview {
    CustomSettingsMenu(
        budgetfb: BudgetFB(),
        onCategoriesUpdate: {
            // Simulate category update in preview
            print("Categories would update here")
        }
    )
}
