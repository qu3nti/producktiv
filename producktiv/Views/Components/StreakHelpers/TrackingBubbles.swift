//
//  TrackingBubbles.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/11/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TrackingBubbles: View {
    var taskIdx: Int
//    var task: TaskModel
    @EnvironmentObject var firebase: Firebase

    
    var body: some View {
        if firebase.tasks.indices.contains(taskIdx) {
            HStack {
                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().fourDaysBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().fourDaysBefore))
                    ))
                    
                    Text(Date().fourDaysBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().threeDaysBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().threeDaysBefore))
                    ))
                    Text(Date().threeDaysBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().twoDaysBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().twoDaysBefore))
                    ))
                    Text(Date().twoDaysBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().dayBefore)) ? "checkmark" : "xmark",
                        size: 33,
                        active: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().dayBefore))

                    ))
                    Text(Date().dayBefore.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                    
                }
                VStack {
                    Button("") {
                        
                    }.buttonStyle(OmniButton(
                        imageSystemName: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().noon)) ? "checkmark" : "xmark",
                        size: 33,
                        active: firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: Date().noon))
                    ))
                    Text(Date().noon.getFormattedDate(format: "E, d MMM"))
                        .font(.caption2)
                        .foregroundColor(Color(hex: 0x758eff))
                }

            }
        }

    }
}
//
//struct TrackingBubbles_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackingBubbles()
//    }
//}
