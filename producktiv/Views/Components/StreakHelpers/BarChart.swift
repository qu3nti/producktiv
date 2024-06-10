//
//  BarChart.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/11/23.
//

import SwiftUI
import Charts

enum AccountType: String {
    case checking = "Checking"
    case savings = "Savings"
    case brokerage = "Brokerage"
    case retirement = "Retirement"
    case college = "College"
    case test = "Test"
    case investment = "Investment"
}

struct Account: Identifiable {
    let id = UUID()
    let accountType: AccountType
    let balance: Double
}

struct BarChart: View {
    
    let accounts = [
        Account(accountType: .checking, balance: 4500),
        Account(accountType: .savings, balance: 58000),
        Account(accountType: .retirement, balance: 25000),
        Account(accountType: .brokerage, balance: 10000),
        Account(accountType: .college, balance: 14000),
//        Account(accountType: .test, balance: 14000),
//        Account(accountType: .investment, balance: 14000),
        

    ]
    
    var body: some View {
        GroupBox("Consistency") {
            Chart {
                    ForEach(accounts) { account in
                        BarMark(x: .value("Account Type", account.accountType.rawValue),
                                y: .value("Balance", account.balance > 10000 ? 2 : 1)
                                ,width: 40
                        )
                        .foregroundStyle(account.balance > 10000 ? Color.blue : Color.red)
                        
                    }
                

            }
            .chartYAxis(.hidden)
//            .frame(width: CGFloat(accounts.count * 50))
        }
        
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
            .environmentObject(Firebase())
    }
}
