//
//  SettingRowView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 03/04/2022.
//

import SwiftUI

struct SettingRowView: View {

    let name: String
    let isChecked: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            SmallCheckBoxView(isChecked: isChecked)
            Text(name)
                .font(.system(size: 16))
                .padding(.leading, 8)
                .foregroundColor(isChecked ? .white : .gray)
                .lineLimit(1)
                .onTapGesture { action() }
            Spacer()
        }
    }
}
