//
//  StatusView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 26/02/2022.
//

import SwiftUI

struct StatusView: View {

    let status: ItemStatus
    let selectAction: (ItemStatus) -> Void
    let allStatuses = ItemStatus.allCases

    @State private var isListVisible = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(status.rawValue)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(4)
                .padding(.horizontal, 8)
                .background(Color("object"))
                .cornerRadius(6)
                .onTapGesture {
                    isListVisible.toggle()
                }
            if isListVisible {
                ForEach(allStatuses, id: \.self) { st in
                    SettingRowView(name: st.rawValue,
                                   isChecked: st == status,
                                   action: {
                        selectAction(st)
                        Haptic.impact(.medium)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isListVisible = false
                            Haptic.impact(.light)
                        }
                    })
                }
            }
        }
    }
}
