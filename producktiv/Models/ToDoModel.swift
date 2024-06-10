//
//  ToDoModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/30/23.
//

import Foundation
import FirebaseFirestore

struct ToDoModel: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let color: Int
    let isPrivate: Bool
    let isFavorite: Bool
    let completed: Bool
    let createdAt: Timestamp
    let completedAt: Timestamp    
}
