//
//  Logo.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/26/23.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack(spacing: 2) {
            Text("pro")
                .font(.largeTitle)
                .foregroundColor(Color(hex: 0x758EFF))
                .fontWeight(.bold)
            Image("duck")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(" tiv")
                .font(.largeTitle)
                .foregroundColor(Color(hex: 0x758EFF))
                .fontWeight(.bold)
        }
    }
}

//struct Logo_Previews: PreviewProvider {
//    static var previews: some View {
//        Logo()
//    }
//}
