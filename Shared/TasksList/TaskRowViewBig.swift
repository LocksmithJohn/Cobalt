//
//  TaskRowView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 04/03/2022.
//

import SwiftUI

struct TaskRowViewBig: View {

    let task: TaskDTOReduced
    let switchAction: () -> Void

    @State var isDone: Bool

    init(task: TaskDTOReduced,
         switchAction: @escaping () -> Void) {
        _isDone = State(initialValue: task.status == .done)
        self.task = task
        self.switchAction = switchAction
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            checkCircle(isDone)
                .offset(y: 10)
                .onTapGesture { // tutaj ta akcja do vm
                    isDone.toggle()
                    Haptic.impact(.medium)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { switchAction() }
                }
            HStack {
                Text(task.name)
                    .foregroundColor(isDone ? Color("inactive") : .white)
                    .strikethrough(isDone)
                    .padding(.leading, 12)

                Spacer()
            }
            .frame(minHeight: 40)
        }
    }

    private func checkCircle(_ isChecked: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill((isChecked) ? Color("inactive") : .blue)
                .frame(width: 28, height: 28)

            RoundedRectangle(cornerRadius: 7)
                .fill(Color("background"))
                .frame(width: 23, height: 23)

            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(Color("inactive"))
            }
        }
    }
}
