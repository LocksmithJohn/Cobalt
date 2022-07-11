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
                currentItemView
                titleView
                segmentedPicker
                newItemView
                confirmButton
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
    }

    private var titleView: some View {
        Text("Change to...").font(.system(size: 32))
            .foregroundColor(.black)
    }

    private var currentItemView: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text(viewModel.previousItem?.name ?? "-")
                Text(viewModel.previousItem?.itemDescriptionShort ?? "-")
                Text(viewModel.previousItem?.itemDescriptionLong ?? "-")
                Spacer()
            }
            Spacer()
        }
        .frame(height: 80)
        .background(Color.blue)
        .cornerRadius(16)
    }

    private var newItemView: some View {
        HStack {
            ProjectRowView(project: <#T##ProjectDTOReduced#>, tapAction: <#T##() -> Void#>)
            Spacer()
            VStack {
                Spacer()
                Text(viewModel.newItem?.name ?? "-")
                Text(viewModel.newItem?.itemDescriptionShort ?? "-")
                Text(viewModel.newItem?.itemDescriptionLong ?? "-")
                Spacer()
            }
            Spacer()
        }
        .frame(height: 80)
        .background(itemColor())
        .cornerRadius(16)

    }

    private func itemColor() -> Color {
        switch viewModel.newItem?.type {
        case .task: return Color.blue
        case .project: return Color.green
        default: return Color.gray
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
