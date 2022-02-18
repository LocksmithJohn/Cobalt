//
//  Tabbar.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct Tabbar: View {


    @State private var tabSelected = 0
    @ObservedObject private var viewModel: TabbarVM

    init(viewModel: TabbarVM) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            switch tabSelected {
            case 0:
                NotesNavigationController()
                    .environmentObject(viewModel.dependency)
            case 1:
                TasksNavigationController()
                    .environmentObject(viewModel.dependency)
            default:
                ProjectsNavigationController()
                    .environmentObject(viewModel.dependency)
            }
            if viewModel.isTabbarVisible {
                tabBarContent
            }
        }
    }

    private var tabBarContent: some View {
        HStack {
            HStack {
                tabItem(iconName: "tray.and.arrow.down",
                        text: "Inbox",
                        tag: 0,
                        color: .yellow)
                Spacer()
                tabItem(iconName: "list.bullet",
                        text: "Tasks",
                        tag: 1,
                        color: .blue)
                Spacer()
                tabItem(iconName: "doc.on.doc",
                        text: "Projects",
                        tag: 2,
                        color: .green)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func tabItem(iconName: String,
                         text: String,
                         tag: Int,
                         color: Color) -> some View {
        VStack(spacing: 8) {
            Spacer()
            Image(systemName: iconName)
                .foregroundColor(tabSelected == tag ? color : .gray)
                .frame(height: 40)
            Text(text).font(.system(size: 14))
                .foregroundColor(tabSelected == tag ? color : .gray)
        }
        .frame(width: 80, height: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            tabSelected = tag
            Haptic.impact(.light)
        }
    }
}
