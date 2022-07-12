//
//  TransformItemView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 19/02/2022.
//

import SwiftUI

struct TransformItemView: View {

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
                .onTapGesture {
                    viewModel.actionSubject.send(.backgroundTapped)
                }
            VStack {
                Spacer()
                itemView(item: viewModel.previousItem)
                    .frame(height: 80)
                titleView
                segmentedPicker
                itemView(item: viewModel.newItem)
                    .frame(height: 80)
                Spacer()
                confirmButton
                    .padding(.bottom, 60)
            }
            .padding(.horizontal)
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
    }

    private var titleView: some View {
        Text("Change to...").font(.system(size: 32))
            .foregroundColor(.black)
    }

    @ViewBuilder private func itemView(item: ItemProtocol?) -> some View {
        if let item = item {
            switch item.type {
            case .project:
                ProjectRowView(project: TransferManager.shared.toProjectDTOReduced(item: item),
                               tapAction: {})
            case .task:
                TaskRowViewBig(task: TransferManager.shared.toTaskDTOReduced(item: item),
                               switchAction: {})
            case .note:
                NoteRowView(note: TransferManager.shared.toNoteDTOReduced(item: item),
                            tapAction: {})
            default:
                Text("tutaj brak widoku").foregroundColor(.white)
            }
        } else {
            EmptyView()
        }
    }

    private var segmentedPicker: some View {
        Picker("", selection: $viewModel.selectedNewItemType) {
            Text("Note").tag(0)
            Text("Task").tag(1)
            Text("Project").tag(2)
            Text("Someday").tag(3)
            Text("Reference").tag(4)
        }
        .pickerStyle(.segmented)
    }

    private var confirmButton: some View {
        Button { viewModel.actionSubject.send(.saveItem)
        } label: { Text("Change").bold().foregroundColor(.black)
        }.buttonStyle(CustomButtonStyle(color: .white))
    }

    @ObservedObject var viewModel: TransformItemVM

    init(viewModel: TransformItemVM) {
        self.viewModel = viewModel
    }
}
