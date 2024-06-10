//
//  LikeModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/23/23.
//

import Foundation
import FirebaseFirestore

struct LikeModel: Codable, Identifiable, Hashable {
    let id: String
    let likerUserName: String
    let likerImg: String
    let timestamp: Timestamp

}
