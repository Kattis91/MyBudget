//
//  PeriodCardView.swift
//  MyBudget
//
//  Created by Katya Durneva Svedmark on 2025-01-16.
//

import SwiftUI

struct PeriodCardView: View {
    let startDate: Date
    let endDate: Date
    
    private var isPeriodActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }
    
    private var daysRemaining: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfEndDate = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfEndDate).day ?? 0
    }
    
    private var daysUntilNextPeriod: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfNextPeriod = calendar.startOfDay(for: startDate)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfNextPeriod).day ?? 0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(isPeriodActive ? "Current Budget Period" : "Coming Budget Period")
                .font(.headline)
                .foregroundColor(Color("SecondaryTextColor"))
            
            Text(DateUtils.formattedDateRange(startDate: startDate, endDate: endDate))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("SecondaryTextColor"))
            
            // Only show if days remaining is positive
            if isPeriodActive {
                Text("~ \(daysRemaining) days remaining ~")
                    .foregroundColor(Color("SecondaryTextColor"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            } else {
                Text("~ Next period starts in \(daysUntilNextPeriod) days ~")
                    .foregroundColor(Color("SecondaryTextColor"))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                    .padding(.vertical, 3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.backgroundTintLight, .backgroundTintDark]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(
            color: .black.opacity(0.3),
            radius: 2,
            x: -2,
            y: 4
        )
        // Add subtle border for more definition
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
        )
    }
}

#Preview {
    PeriodCardView(
        startDate: Date(), // Current date
        endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date() // 30 days from now
    )
}
