//
//  NotificationModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/27/23.
//

import Foundation
import FirebaseFirestore

struct NotificationModel: Codable, Hashable, Identifiable {
    let id: String
    let notifierUserId: String
    let notifierUserName: String
    let notifierImg: String
    let message: String
    let timestamp: Timestamp
}
