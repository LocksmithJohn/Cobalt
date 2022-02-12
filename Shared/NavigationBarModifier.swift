//
//  NavigationBarModifier.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {

    let title: String?
    let leftImageView: AnyView?
    let leftButtonAction: (() -> Void)?
    let rightImageView: AnyView?
    let rightButtonAction: (() -> Void)?
    let syncDate: Binding<String?>?
    let mainColor: Color
    let identifier: Identifier

    init(_ title: String? = nil,
         leftImageView: AnyView? = nil,
         leftButtonAction: (() -> Void)? = nil,
         rightImageView: AnyView? = nil,
         rightButtonAction: (() -> Void)? = nil,
         syncDate: Binding<String?>? = nil,
         mainColor: Color = .white) {
        self.title = title
        self.leftImageView = leftImageView
        self.leftButtonAction = leftButtonAction
        self.rightImageView = rightImageView
        self.rightButtonAction = rightButtonAction
        self.syncDate = syncDate
        self.mainColor = mainColor
        self.identifier = identifier
    }

    func body(content: Content) -> some View {
        VStack {
            NavigationBar(syncDate: syncDate ?? .constant(nil),
                          title: title,
                          leftImageView: leftImageView,
                          leftButtonAction: leftButtonAction,
                          rightImageView: rightImageView,
                          rightButtonAction: rightButtonAction,
                          mainColor: mainColor)
            Spacer()
            content
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        }
    }

}
