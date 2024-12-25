//
//  ExpensesView.swift
//  MyBudget
//
//  Created by Katya Durneva Svedmark on 2024-12-09.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ExpensesView: View {
    
    var viewtype : ExpenseViewType
    
    @State var categories: [String]
    @State var selectedCategory: String
    @State var newCategory: String = ""
    
    @State var expenseAmount: String = ""
    @State var errorMessage = ""
    
    @Binding var totalExpenses: Double
    @Binding var expenseList: [Expense]
    
    @State var showNewCategoryField = false
    
    // @ObservedObject var expenseData: ExpenseData
    
    @State var budgetfb = BudgetFB()
    
   
    
    // Custom initializer to avoid private issues
    /*
    init(categories: [String], selectedCategory: String, expenseList: Binding<[Expense]>, totalExpenses: Binding<Double>) {
        self.categories = categories
        self._selectedCategory = State(initialValue: selectedCategory)
        self._expenseList = expenseList
        self._totalExpenses = totalExpenses
        self._expenseData = .init(initialValue: ExpenseData())
    }
    */
    var body: some View {
        
        VStack {
            CustomTextFieldView(placeholder: "Expense amount", text: $expenseAmount, isSecure: false, onChange: {
                errorMessage = ""
            }, leadingPadding: 33, trailingPadding: 33, systemName: "minus.circle")
            
            if showNewCategoryField {
                CustomTextFieldView(placeholder: "New category", text: $newCategory, isSecure: false, leadingPadding: 55, trailingPadding: 55, systemName: "square.grid.2x2")
            } else {
                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(category) {
                            selectedCategory = category
                        }
                    }
                    Button("+ Add new category") {
                        selectedCategory = "new"
                        showNewCategoryField = true
                    }
                } label: {
                    HStack {
                        Text(selectedCategory.isEmpty ? "Category" : selectedCategory)
                            .foregroundColor(selectedCategory.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding(.bottom)
                .padding(.horizontal, 33)
            }
        }
        
        ErrorMessageView(errorMessage: errorMessage, height: 15)
    
        Button(action: {
            if let expense = Double(expenseAmount) {
                if expense > 0.00 {
                    if showNewCategoryField {
                        if !newCategory.isEmpty {
                            categories.append(newCategory)
                            let categoryToUse = newCategory
                            expenseAmount = ""
                            budgetfb.saveExpenseData(amount: expense, category: categoryToUse, isfixed: ( viewtype == .fixed ))
                            showNewCategoryField = false
                            selectedCategory = ""
                        } else {
                            errorMessage = "Please add a category"
                        }
                    } else {
                        if !selectedCategory.isEmpty {
                            let categoryToUse = selectedCategory
                            expenseAmount = ""
                            budgetfb.saveExpenseData(amount: expense, category: categoryToUse, isfixed: ( viewtype == .fixed )) 
                            selectedCategory = ""
                        } else {
                            errorMessage = "Please select a category."
                        }
                    }
                } else {
                    errorMessage = "Amount must be greater than zero."
                }
            } else {
                errorMessage = "Amount must be a number."
            }
        }) {
            ButtonView(buttontext: "Add expense", leadingPadding: 33, trailingPadding: 33)
        }
        
        if viewtype == .fixed {
            CustomListView(
                items: budgetfb.fixedExpenseList,
                deleteAction: deleteFixedExpense,
                itemContent: { expense in
                    (category: expense.category, amount: expense.amount)
                }, showNegativeAmount: true
            )
        } else {
            CustomListView(
                items: budgetfb.variableExpenseList,
                deleteAction: deleteVariableExpense,
                itemContent: { expense in
                    (category: expense.category, amount: expense.amount)
                }, showNegativeAmount: true
            )
        }
    }
    
    // Bridge function for Fixed
    private func deleteFixedExpense(at offsets: IndexSet) {
        budgetfb.deleteExpense(from: "fixed", at: offsets)
    }
    
    // Bridge function for Variable
    private func deleteVariableExpense(at offsets: IndexSet) {
        budgetfb.deleteExpense(from: "variable", at: offsets)
    }
}

#Preview {
    ExpensesView(
        viewtype: .fixed, categories: ["Rent", "Water", "Electricity"],
        selectedCategory: "Rent",
        totalExpenses: .constant(100.0), expenseList: .constant([]),
        budgetfb: BudgetFB()
    )
}
