//
//  SearchView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/03/2022.
//

import SwiftUI

struct SearchView: View {

    var body: some View {
        VStack {
            inputText
                .padding(.top, 30)
            scrollView
        }
//        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "xmark")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    private var scrollView: some View {
        ScrollView {
            VStack {
                ForEach(searchResults) { item in
                    HStack {
                        itemView(type: item.type, name: item.name)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var inputText: some View {
        HStack {
            TextField("Search", text: $viewModel.searchText, prompt: Text("Search..."))
                .font(.system(size: 32))
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
    }

    var searchResults: [ItemReduced] { // tutaj do view modelu
        if viewModel.searchText.isEmpty {
            return []
        } else {
            return viewModel.filteredItems
        }
    }

    @ViewBuilder private func itemView(type: ItemType, name: String) -> some View {
            switch type {
            case .project:
                ProjectRowView(project: ProjectDTOReduced(name: name), tapAction: {})
            case .task, .nextAction, .waitFor:
                TaskRowViewBig(task: TaskDTOReduced(name: name),
                               switchAction: {})
            case .note:
                NoteRowView(note: NoteDTOReduced(name: name),
                            tapAction: {})
            default:
                Text("tutaj brak widoku").foregroundColor(.white)
            }
    }

    @ObservedObject private var viewModel: SearchVM

    init(viewModel: SearchVM) {
        self.viewModel = viewModel
    }

}
