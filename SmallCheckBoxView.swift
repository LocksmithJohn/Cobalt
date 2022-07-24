//
//  SmallCheckBoxView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 03/04/2022.
//

import SwiftUI

struct SmallCheckBoxView: View {

    let isChecked: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("inactive"))
                .frame(width: 22, height: 22)
            RoundedRectangle(cornerRadius: 7)
                .fill(isChecked ? Color.gray : Color("background"))
                .frame(width: 16, height: 16)
        }
    }
}
