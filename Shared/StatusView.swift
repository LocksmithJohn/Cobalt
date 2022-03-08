//
//  StatusView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 26/02/2022.
//

import SwiftUI

struct StatusView: View {

    let status: ItemStatus

    var body: some View {
        HStack {
            Text(status.rawValue)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(4)
                .padding(.horizontal, 8)
                .background(Color.green.opacity(0.3))
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.green, lineWidth: 1))
            
        }
    }
}
