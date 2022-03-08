//
//  MoreView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 06/03/2022.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        Form {
            Section {
                row(title: "Areas of focus")
                row(title: "Someday/Maybe")
                row(title: "Control lists")
                row(title: "References")
            }
        }
    }

    private func row(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: "chevron.forward")
        }
    }
}
