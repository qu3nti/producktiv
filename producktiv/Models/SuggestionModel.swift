//
//  SuggestionModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 4/2/23.
//

import Foundation
import FirebaseFirestore

struct SuggestionModel: Codable, Hashable, Identifiable {
    let id: String
    let suggestion: String
    let suggester: String
    let timestamp: Timestamp

}
