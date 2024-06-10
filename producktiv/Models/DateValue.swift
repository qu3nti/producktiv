//
//  DateValue.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/25/23.
//

import Foundation

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
