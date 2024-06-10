//
//  PostModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/19/23.
//

import Foundation
import FirebaseFirestore

struct PostModel: Codable, Identifiable, Hashable {
    let id: String
    let authorId: String
    let authorUserName: String
    let authorImg: String
    let timestamp: Timestamp
    let celebrateCount: Int
    let commentCount: Int
    let content: String
    let celebratorIds: [String]

}
