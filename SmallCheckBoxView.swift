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
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("inactive"))
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 5)
                .fill(isChecked ? Color.gray : Color("background"))
                .frame(width: 14, height: 14)
        }
    }
}
