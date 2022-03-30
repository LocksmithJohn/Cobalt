//
//  ContentView.swift
//  Shared
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct ContentView: View {

    let dependency = Dependency()

    @ObservedObject private var viewModel = ContentVM()
    @State private var settingVisible = false

    var body: some View {
        GeometryReader { g in
            ZStack {
                MoreNavigationController()
                    .environmentObject(dependency)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("background").ignoresSafeArea())
                TabbarView(viewModel: TabbarVM(dependency: dependency))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: settingVisible ? g.size.width : 0)
            }
        }
        .onChange(of: viewModel.settingVisible) { newValue in
            Haptic.impact(.light)
            withAnimation(.easeInOut(duration: 0.15)) {
                settingVisible = newValue
            }
        }
    }
}
