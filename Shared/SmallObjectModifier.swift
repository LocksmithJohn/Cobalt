//
//  SmallObjectModifier.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 02/04/2022.
//

import SwiftUI

struct SmallObjectModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding(4)
            .padding(.horizontal, 8)
            .background(Color("object"))
            .cornerRadius(6)
    }
    
}
