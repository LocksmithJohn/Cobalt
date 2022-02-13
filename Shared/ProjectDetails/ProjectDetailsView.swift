//
//  ProjectDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct ProjectDetailsView: View {
    var body: some View {
        Form {
            // tutaj ponizej wrzucic nowe inity textfieldow dla ios15
            TextField(viewModel.projectName, text: $viewModel.projectName)
            TextField(viewModel.projectDescription, text: $viewModel.projectDescription)
            Button { viewModel.actionSubject.send(.saveProject) } label:
            { Text("Save").foregroundColor(.red) }
            Button {
                viewModel.actionSubject.send(.deleteProject)
                
            } label:
            { Text("Delete").foregroundColor(.red) }

        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: ProjectDetailsVM

    init(viewModel: ProjectDetailsVM) {
        self.viewModel = viewModel
    }
}
