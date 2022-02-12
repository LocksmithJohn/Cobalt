//
//  SwiftUIView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct TasksListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

    @ObservedObject var viewModel: TasksListVM

    init(viewModel: TasksListVM) {
        self.viewModel = viewModel
    }
}
