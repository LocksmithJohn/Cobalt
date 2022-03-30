//
//  NavigationBar.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct NavigationBar: View {

    private enum Constants {
        static let height: CGFloat = 50
    }

    @Binding var syncDate: String?

    let title: String?
    let leftImageView: AnyView?
    let leftButtonAction: (() -> Void)?
    let rightImageView: AnyView?
    let rightButtonAction: (() -> Void)?
    let mainColor: Color

    var body: some View {
        ZStack {
            if let title = title {
                Text(title)
                    .foregroundColor(mainColor)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color("background").cornerRadius(8))
                    .frame(height: 40)
            }
            HStack {
                if let leftButtonImage = leftImageView {
                    ZStack {
                        itemBackground(size: CGSize(width: 30, height: 30))
                        Button(action: { leftButtonAction?() },
                               label: { leftButtonImage.foregroundColor(mainColor) })
                            .padding()
                    }
                }
                Spacer()
                if let rightButtonImage = rightImageView {
                    ZStack {
                        itemBackground(size: CGSize(width: 30, height: 30))
                        Button(action: { rightButtonAction?() },
                               label: { rightButtonImage.foregroundColor(mainColor) })
                            .padding()
                    }
                }
            }
            if let date = syncDate {
                HStack {
                    Spacer()
                    Text(date)
                        .font(.system(size: 12))
                        .padding()
                }
            }
        }
        .frame(height: Constants.height)
//                .background(Color.red)
    }

    private func itemBackground(size: CGSize) -> some View {
        VStack{}
        .frame(width: size.width, height: size.height)
        .background(Color("background").opacity(1))
        .cornerRadius(8)
    }
}
