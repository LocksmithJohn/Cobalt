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
    let smallIcon: Bool

    @State var isDone: Bool

    init(task: TaskDTOReduced,
         smallIcon: Bool,
         switchAction: @escaping () -> Void) {
        _isDone = State(initialValue: task.status == .done)
        self.task = task
        self.switchAction = switchAction
        self.smallIcon = smallIcon
    }

    var body: some View {
        HStack(alignment: .top, spacing: smallIcon ? 4 : 16) {
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
            RoundedRectangle(cornerRadius: smallIcon ? 8 : 10)
                .fill((isChecked || smallIcon) ? Color("inactive") : .blue)
                .frame(width: smallIcon ? 20 : 28, height: smallIcon ? 20 : 28)

            RoundedRectangle(cornerRadius: smallIcon ? 6 : 7)
                .fill(Color("background"))
                .frame(width: smallIcon ? 16 : 23, height: smallIcon ? 16 : 23)

            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: smallIcon ? 10 : 16, weight: .bold, design: .default))
                    .foregroundColor(Color("inactive"))
            }
        }
    }
}
