//
//  TaskRowViewSmall.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 06/04/2022.
//

import SwiftUI

struct TaskRowViewSmall: View {

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
        HStack(alignment: .top, spacing: 4) {
            checkCircle(isDone)
                .padding(.top, 1)
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
                    .font(.system(size: 18, weight: .light))

                Spacer()
            }
        }
    }

    private func checkCircle(_ isChecked: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("inactive"))
                .frame(width: 20, height: 20)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color("background"))
                .frame(width: 16, height: 16)

            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold, design: .default))
                    .foregroundColor(Color("inactive"))
            }
        }
    }
}
