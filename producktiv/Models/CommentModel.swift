//
//  CommentModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/22/23.
//

import Foundation
import FirebaseFirestore

struct CommentModel: Codable, Identifiable, Hashable {
    let id: String
    let authorId: String
    let authorUserName: String
    let authorImg: String
    let timestamp: Timestamp
    let comment: String

}
