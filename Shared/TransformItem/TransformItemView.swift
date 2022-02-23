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
            Color.black.ignoresSafeArea().opacity(0.4)
                .onTapGesture {
                    viewModel.actionSubject.send(.backgroundTapped)
                }
            VStack {
                Spacer()
                Text("Change to...").font(.system(size: 32))
                    .padding(.vertical)
                Button {
                    viewModel.actionSubject.send(.typeSelected(.task))
                } label: {
                    Text("Task")
                }.buttonStyle(CustomButtonStyle(color: .gray))

                Button {
                    viewModel.actionSubject.send(.typeSelected(.project))
                } label: { Text("Project") }.buttonStyle(CustomButtonStyle(color: .gray))
                HStack(spacing: 8) {
                    Button {
                        viewModel.actionSubject.send(.typeSelected(.reference))
                    } label: { Text("SomeDay") }.buttonStyle(CustomButtonStyle(color: .gray))
                    Button {
                        viewModel.actionSubject.send(.typeSelected(.reference))
                    } label: { Text("Reference") }.buttonStyle(CustomButtonStyle(color: .gray))
                }
                Spacer().frame(height: 24)
                Button {
                    viewModel.actionSubject.send(.saveItem)
                } label: {
                    Text(viewModel.newItem?.type.rawValue ?? "-")
                    .bold()
                }.buttonStyle(CustomButtonStyle(color: .blue))
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
    }

    @ObservedObject var viewModel: TransformItemVM

    init(viewModel: TransformItemVM) {
        self.viewModel = viewModel
    }
}


struct CustomButtonStyle: ButtonStyle { // tutaj przeniesc
    var color: Color = .gray
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 40)
        //            .padding(4)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(7)
    }
}
