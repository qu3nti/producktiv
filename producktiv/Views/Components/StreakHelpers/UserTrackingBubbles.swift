//
//  UserTrackingBubbles.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/17/23.
//

import SwiftUI

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserTrackingBubbles: View {
    var task: TaskModel

    
    var body: some View {
            HStack {
                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: task.daysCompleted.contains(Timestamp(date: Date().fourDaysBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: task.daysCompleted.contains(Timestamp(date: Date().fourDaysBefore))
                    ))
                    
                    Text(Date().fourDaysBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: task.daysCompleted.contains(Timestamp(date: Date().threeDaysBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: task.daysCompleted.contains(Timestamp(date: Date().threeDaysBefore))
                    ))
                    Text(Date().threeDaysBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: task.daysCompleted.contains(Timestamp(date: Date().twoDaysBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: task.daysCompleted.contains(Timestamp(date: Date().twoDaysBefore))
                    ))
                    Text(Date().twoDaysBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: task.daysCompleted.contains(Timestamp(date: Date().dayBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: task.daysCompleted.contains(Timestamp(date: Date().dayBefore))

                    ))
                    Text(Date().dayBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                    
                }
                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: task.daysCompleted.contains(Timestamp(date: Date().noon)) ? "checkmark" : "xmark",
                        size: 33,
                        active: task.daysCompleted.contains(Timestamp(date: Date().noon))
                    ))
                    Text(Date().noon.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

            }
    }
}
