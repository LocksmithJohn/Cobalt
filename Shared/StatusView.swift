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
                .padding()
                .padding(.bottom, 3)
        }
        .frame(height: 22)
        .background(Color.gray.opacity(0.4))
        .cornerRadius(6)
//        .overlay(RoundedRectangle(cornerRadius: 6)
//                    .stroke(Color.gray, lineWidth: 2))
    }
}
