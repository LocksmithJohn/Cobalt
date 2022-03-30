//
//  SearchView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/03/2022.
//

import SwiftUI

struct SearchView: View {

    @State private var searchText = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText, prompt: Text("Search..."))
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            ScrollView {
                VStack {
                    ForEach(searchResults, id: \.self) { name in
                        HStack {
                        Text(name)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "xmark")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    var searchResults: [String] { // tutaj do view modelu
        if searchText.isEmpty {
            return []
        } else {
            return viewModel.items
                .filter { $0.name.contains(searchText) } // tutaj nie spradza po description
                .map { String($0.name.prefix(10)) }
        }
    }

    @ObservedObject private var viewModel: SearchVM

    init(viewModel: SearchVM) {
        self.viewModel = viewModel
    }

}
