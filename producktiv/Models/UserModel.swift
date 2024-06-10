//
//  UserModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/10/23.
//

import Foundation

struct UserModel: Codable, Hashable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let userName: String
    let email: String
    let icon: String
    let newNotifications: Bool
}
