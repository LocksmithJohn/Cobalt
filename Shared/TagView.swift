//
//  TagView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 07/04/2022.
//

import Foundation

import SwiftUI

struct TagView: View {

    let tag: String
    let selectAction: (String) -> Void
    let allTags = [String]()

    @State private var isListVisible = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(tag)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(4)
                .padding(.horizontal, 8)
                .background(Color("object"))
                .cornerRadius(6)
                .onTapGesture {
                    Haptic.impact(.light)
                    isListVisible.toggle()
                }
            if isListVisible {
                VStack {
                    ForEach(array, id: \.self) { t in
                        SettingRowView(name: t,
                                       isChecked: t == tag,
                                       action: {
                            selectAction(t)
                            Haptic.impact(.medium)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isListVisible = false
                                Haptic.impact(.light)
                            }
                        })
                    }
                }
                .background(Color("object"))
                .cornerRadius(6)
            }
        }
    }

    let array = [
        "tag1",
        "tag2",
        "tag3",
        "tag4",
        "tag5"
    ]
}
