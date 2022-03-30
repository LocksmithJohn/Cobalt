//
//  CustomButtonStyle.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 30/03/2022.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var color: Color = .gray
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(7)
    }
}
