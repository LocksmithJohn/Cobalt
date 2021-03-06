//
//  Tabbar.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct TabbarView: View {

    @ObservedObject private var viewModel: TabbarVM

    init(viewModel: TabbarVM) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch viewModel.tabSelected {
                case 0:
                    NotesNavigationController()
                        .environmentObject(viewModel.dependency)
                        .background(Color("background"))
                        .ignoresSafeArea()
                case 1:
                    TasksNavigationController()
                        .environmentObject(viewModel.dependency)
                        .background(Color("background"))
                        .ignoresSafeArea()
                case 2:
                    ProjectsNavigationController()
                        .environmentObject(viewModel.dependency)
                        .background(Color("background"))
                        .ignoresSafeArea()
                default:
                    MoreNavigationController()
                        .environmentObject(viewModel.dependency)
                        .background(Color("background"))
                        .ignoresSafeArea()
                }
                if viewModel.isTabbarVisible {
                    tabBarContent
                }
            }
            .blur(radius: viewModel.popoverVM != nil ? 10 : 0)
            if let popoverVM  = viewModel.popoverVM {
                PopoverView(viewModel: popoverVM)
                    .animation(.easeIn(duration: 0.1))
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
                        text: "Actions",
                        tag: 1,
                        color: .blue)
                Spacer()
                tabItem(iconName: "doc.on.doc",
                        text: "Projects",
                        tag: 2,
                        color: .green)
                Spacer()
                tabItem(iconName: "list.bullet",
                        text: "More",
                        tag: 3,
                        color: .green)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
        .background(Color("background").ignoresSafeArea())
    }

    private func tabItem(iconName: String,
                         text: String,
                         tag: Int,
                         color: Color) -> some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: iconName)
                .foregroundColor(viewModel.tabSelected == tag ? color : .gray)
                .frame(height: 40)
            Text(text).font(.system(size: 14))
                .foregroundColor(viewModel.tabSelected == tag ? color : .gray)
        }
        .frame(width: 80, height: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.tabSelected = tag
            Haptic.impact(.light)
        }
    }
}
