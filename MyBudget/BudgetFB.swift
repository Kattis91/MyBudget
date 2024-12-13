//
//  BudgetFB.swift
//  MyBudget
//
//  Created by Katya Durneva Svedmark on 2024-12-01.
//

import Foundation
import Firebase
import FirebaseAuth

@Observable class BudgetFB {
    
    var loginerror : String?
    
    func userLogin(email : String, password : String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
                print("Successfully logged in")
                completion(nil)
            } catch {
                print("Login failed: \(error.localizedDescription)")
                completion(error.localizedDescription) // Return Firebase error
            }
        }
    }
    
    func userRegister(email: String, password: String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                let regResult = try await Auth.auth().createUser(withEmail: email, password: password)
                print("Registration successful for user: \(regResult.user.email ?? "Unknown")")
                completion(nil)
            } catch {
                print("Registration failed: \(error.localizedDescription)")
                completion(error.localizedDescription) // Return Firebase error
            }
        }
    }
    
    func userLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func forgotPassword(email : String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Sent!")
                completion(nil)
            } catch {
                print("Reset failed: \(error.localizedDescription)")
                completion(error.localizedDescription)
            }
        }
    }
    
    func saveIncomeData(amount: Double, category: String) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userid = Auth.auth().currentUser!.uid
        
        let incomeEntry: [String: Any] = [
            "amount": amount,
            "category": category,
            ]
        
        ref.child("incomes").child(userid).childByAutoId().setValue(incomeEntry)
        
        
    }
    
    func saveExpenseData(amount: Double, category: String, isfixed: Bool) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userid = Auth.auth().currentUser!.uid
        
        let expenseEntry: [String: Any] = [
            "amount": amount,
            "category": category,
            "isfixed": isfixed
            ]
        
        ref.child("expenses").child(userid).childByAutoId().setValue(expenseEntry)
    }

    
    func loadIncomeData(incomeData: IncomeData) async {
        
        guard let userid = Auth.auth().currentUser?.uid else { return }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        do {
            let incomedata = try await ref.child("incomes").child(userid).getData()
            print(incomedata.childrenCount)
            
            incomeData.incomeList = []
            
            for incomeitem in incomedata.children {
                let incomesnap = incomeitem as! DataSnapshot
                
                // Access the "income data" child
                guard let incomeDataDict = incomesnap.value as? [String: Any]
                else {
                    print("Failed to get income data")
                    continue
                }
                
                print(incomeDataDict)
                
                let fetchedIncome = Income(
                    id: incomesnap.key,
                    amount: incomeDataDict["amount"] as? Double ?? 0.0,  // Default to 0.0 if not found
                    category: incomeDataDict["category"] as? String ?? "Unknown"  // Default to "Unknown" if not found
                )
                incomeData.incomeList.append(fetchedIncome)
            }
            
            // Calculate total income
            let totalIncome = incomeData.incomeList.reduce(0.0) { (sum, income) in
                return sum + income.amount
            }
            
            print("Total Income: \(totalIncome)")
            incomeData.totalIncome = totalIncome
            
        } catch {
            // Something went wrong
            print("Something went wrong!")
        }
        
    }
    
    func deleteIncome(at offsets: IndexSet, incomeData: IncomeData) {
       let userid = Auth.auth().currentUser?.uid
       guard let userid else { return }
       
       var ref: DatabaseReference!
       ref = Database.database().reference()
       
       for offset in offsets {
           print("DELETE \(offset)")
           let incomeItem = incomeData.incomeList[offset]
           print(incomeItem.id)
           print(incomeItem.category)
           ref.child("incomes").child(userid).child(incomeItem.id).removeValue()
       }
       
       // Update local data
       incomeData.incomeList.remove(atOffsets: offsets)
       
       // Recalculate total income
       incomeData.totalIncome = incomeData.incomeList.reduce(0.0) { $0 + $1.amount }
   }
    
    func loadExpenseData(expenseData: ExpenseData) async {
        
        guard let userid = Auth.auth().currentUser?.uid else { return }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        do {
            let expensedata = try await ref.child("expenses").child(userid).getData()
            print(expensedata.childrenCount)
            
            expenseData.variableExpenseList = []
            expenseData.fixedExpenseList = []
            
            for expenseitem in expensedata.children {
                let expensesnap = expenseitem as! DataSnapshot
                
                // Access the "income data" child
                guard let expenseDataDict = expensesnap.value as? [String: Any]
                else {
                    print("Failed to get income data")
                    continue
                }
                
                print(expenseDataDict)
                
                let fetchedExpense = Expense(
                    id: expensesnap.key,
                    amount: expenseDataDict["amount"] as? Double ?? 0.0,  // Default to 0.0 if not found
                    category: expenseDataDict["category"] as? String ?? "Unknown",
                    isfixed: expenseDataDict["isfixed"] as? Bool ?? false  // Default to "Unknown" if not found
                )
                
                if fetchedExpense.isfixed {
                    expenseData.fixedExpenseList.append(fetchedExpense)
                } else {
                    expenseData.variableExpenseList.append(fetchedExpense)
                }
            }
            
            // Calculate total expense
            
            let FixedExpensesSum = expenseData.fixedExpenseList.reduce(0.0) { (sum, expense) in
                 return sum + expense.amount
            }
             
            let VariableExpensesSum = expenseData.variableExpenseList.reduce(0.0) { (sum, expense) in
                 return sum + expense.amount
            }
             
            let totalExpenses = FixedExpensesSum + VariableExpensesSum
            expenseData.totalExpenses = totalExpenses
        
        } catch {
            // Something went wrong
            print("Something went wrong!")
        }
    }
    
}
