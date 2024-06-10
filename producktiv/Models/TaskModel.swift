//
//  TaskModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import Foundation
import FirebaseFirestore

struct TaskModel: Codable, Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let description: String
    let img: String
    let isFavorite: Bool
    let isPrivate: Bool
    let currentStreak: Int
    let longestStreak: Int
    let daysCompleted: [Timestamp]
    let exactTimes: [Timestamp]
    let lastUpdated: Timestamp
    let completedToday: Bool

}
