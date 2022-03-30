//
//  NoteRowView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/03/2022.
//

import SwiftUI

struct NoteRowView: View {
    let note: NoteDTOReduced
    let tapAction: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomLeading) {
                Text(note.name)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }
            .frame(maxHeight: 80)
            .background(Color("object"))
            .cornerRadius(8)
            .onTapGesture {
                tapAction()
            }
            Spacer()
        }
    }

    private var yellowCorner: some View {
        Path { path in
            path.move(to: CGPoint(x: 16, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 16))
            path.addLine(to: CGPoint(x: 16, y: 0))
        }
        .fill(.yellow.opacity(0.4))
    }
}
