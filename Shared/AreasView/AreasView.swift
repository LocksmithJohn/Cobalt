//
//  AreasView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 21/07/2022.
//

import SwiftUI

struct AreasView: View {

    @State var areaToAdd: String = ""

    var body: some View {
        List {
            Text("tutaj areas")
            ForEach(viewModel.focusAreas.areas, id: \.self) { area in
                Text(area)
                    .frame(minWidth: 30)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.actionSubject
                            .send(.deleteArea(name: area))
                    }
            }
            TextField("Add area", text: $areaToAdd) {

            }.onSubmit {
                viewModel.actionSubject
                    .send(.addArea(name: areaToAdd))
                areaToAdd = ""
            }
        }
        .onAppear {
            print("filter view onAppearAction()")
            print("filter view onAppearAction() count: \(viewModel.focusAreas.areas.count)")

            viewModel.actionSubject.send(.onAppear)
        }
    }

    @ObservedObject var viewModel: AreasVM

    init(viewModel: AreasVM) {
        self.viewModel = viewModel
    }

}
