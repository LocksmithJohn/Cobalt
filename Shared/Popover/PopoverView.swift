//
//  PopoverView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 21/02/2022.
//

import SwiftUI

struct PopoverView: View {
    
    private var viewModel: PopoverVM
    
    init(viewModel: PopoverVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if let viewModel = viewModel as? TransformItemVM {
            TransformItemView(viewModel: viewModel)
        } else {
            EmptyView()
        }
    }
}
