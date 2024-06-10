//
//  BadgeModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/31/23.
//

import Foundation
import FirebaseFirestore

struct BadgeModel: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let streakOrToDo: String
    let count: Int
    let timestamp: Timestamp
}
