//
//  TaskRowView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 04/03/2022.
//

import SwiftUI

struct TaskRowView: View {

    let task: TaskDTOReduced
    let switchAction: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: task.status == .done ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    Haptic.impact(.medium)
                    switchAction()
                }
            Text(task.name)
                .padding(.bottom, 4)
            Spacer()
        }
    }
}
