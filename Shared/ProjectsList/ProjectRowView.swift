//
//  ProjectRowView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 24/03/2022.
//

import SwiftUI

struct ProjectRowView: View {

    let project: ProjectDTOReduced
    let tapAction: () -> Void

    @State private var isDone: Bool
    @State private var isInProgress: Bool

    init(project: ProjectDTOReduced,
         tapAction: @escaping () -> Void) {
        _isDone = State(initialValue: project.status == .done)
        _isInProgress = State(initialValue: project.status == .inProgress)
        self.project = project
        self.tapAction = tapAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 40) {
                Text(project.name)
                    .strikethrough(isDone)
                    .foregroundColor(isDone ? .gray : .white)
                    .frame(maxHeight: 50)
                Spacer()
            }
            HStack(alignment: .bottom) {
                dotView
                Text(project.status.rawValue)
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.gray)
                    .offset(x: -2, y: 3.5)
            }
        }
        .padding(10)
        .background(Color("object"))
        .cornerRadius(10)
        .onTapGesture { tapAction() }
    }

    private var dotView: some View {
        ZStack {
            if isDone {
                Circle()
                    .fill(Color("background"))
                    .frame(width: 8, height: 8)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    if !isInProgress {
                        Circle()
                            .fill(Color("object"))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            ProjectRowView(project: ProjectDTOReduced(), tapAction: {} )
                .padding()
        }
    }
}
