//
//  HomeViewEmpty.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/23/23.
//

import SwiftUI

struct HomeViewEmpty: View {
    @Binding var page: String
    var body: some View {
        VStack(alignment: .center) {
            Logo()
            Spacer()
            HStack {
                Text("Go to ")
                    .foregroundColor(Color(hex: 0x758EFF))
                    .fontWeight(.bold)
                    .font(.headline)
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.page = "add"
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                        .padding()
                        .background(Color(hex: 0xffb258))
                        .clipShape(Circle())
                }
                Text(" to add a new streak!")
                    .foregroundColor(Color(hex: 0x758EFF))
                    .fontWeight(.bold)
                    .font(.headline)
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}

//struct HomeViewEmpty_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeViewEmpty()
//    }
//}
