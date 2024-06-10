//
//  ReportBugModel.swift
//  producktiv
//
//  Created by Quentin Pompliano on 4/2/23.
//

import Foundation
import FirebaseFirestore

struct ReportBugModel: Codable, Hashable, Identifiable {
    let id: String
    let report: String
    let reporter: String
    let timestamp: Timestamp
}
