//
//  ContentView.swift
//  Shared
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct ContentView: View {

    let dependency = Dependency()

    var body: some View {
        Tabbar().environmentObject(dependency)
    }
}
