//
//  Tabbar.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct Tabbar: View {

    @EnvironmentObject var dependency: Dependency

    @State private var tabSelected = 0

    var body: some View {
        VStack(spacing: 0) {
            if dependency.appState.isTabbarVisibleSubject.value {
                switch tabSelected {
                case 0:
                    NotesNavigationController()
                        .environmentObject(dependency)
                case 1:
                    TasksNavigationController()
                        .environmentObject(dependency)
                default:
                    ProjectsNavigationController()
                        .environmentObject(dependency)
                }
                HStack {
                    tabItem(iconName: "tray.and.arrow.down",
                            text: "Inbox",
                            tag: 0,
                            color: .white)
                    Spacer()
                    tabItem(iconName: "list.bullet",
                            text: "Tasks",
                            tag: 1,
                            color: .white)
                    Spacer()
                    tabItem(iconName: "doc.on.doc",
                            text: "Projects",
                            tag: 2,
                            color: .white)
                }
                .padding(.bottom, 30)
                .padding(.horizontal, 30)
            }
        }
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
//            Haptic.impact(.light) tutaj
        }
    }
}
