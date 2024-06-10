//
//  OmniButton.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct OmniButton: ButtonStyle {
    var imageSystemName: String
    var size: CGFloat
    var active: Bool
    


    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .padding()
            .background(active ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
            .clipShape(Circle())
    }
}
