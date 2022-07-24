//
//  MoreView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 06/03/2022.
//

import SwiftUI

struct MoreView: View {

    @State var searchText = ""

    var body: some View {
        VStack {
            Form {
                Section("Things") {
                    row(title: "Areas of focus", tapAction: { viewModel.actionSubject.send(.showAreas)
                    })
                    row(title: "Someday/Maybe")
                    row(title: "Control lists")
                    row(title: "References")
                    row(title: "Export", tapAction: { viewModel.actionSubject.send(.showExport)
                        })
                }
                Section("Settings") {
                    row(title: "Profile")
                    row(title: "Pro")
                }
            }
            .background(Color("background").ignoresSafeArea())
            HStack {
                Text("Search ...")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture { viewModel.actionSubject.send(.showSearch) }
        }
        .modifier(NavigationBarModifier(
            "",
            rightImageView: AnyView(Image(systemName: "square.righthalf.filled")),
            rightButtonAction: { GlobalRouter.shared.settingsVisible.send(false) })
        )
    }

    private func row(title: String,
                     imageName: String? = nil,
                     tapAction: (() -> Void)? = nil)  -> some View {
        HStack {
            Text(title)
            Spacer()
            if let imageName = imageName {
                Image(systemName: imageName)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { tapAction?() }
    }

    @ObservedObject private var viewModel: MoreVM

    init(viewModel: MoreVM) {
        self.viewModel = viewModel
        UIScrollView.appearance().backgroundColor = .clear
    }
}
