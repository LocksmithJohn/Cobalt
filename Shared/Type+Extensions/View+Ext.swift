//
//  View+Ext.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 20/02/2022.
//

import SwiftUI

//extension View {
//
//    @ViewBuilder func showPopOver(_ viewModel: BaseVM?) -> some View {
//        if let viewModel = viewModel as? TransformItemVM {
//            self.modifier(TransformViewModifier(viewModel: viewModel))
//        } else {
//            self
//        }
//    }
//
//}
//
//import SwiftUI
//
//struct TransformViewModifier: ViewModifier {
//
//    @ObservedObject var viewModel: TransformItemVM
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content.blur(radius: 5)
//            TransformItemView(viewModel: viewModel)
//                .cornerRadius(16)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding()
//
//        }
//    }
//
//}
