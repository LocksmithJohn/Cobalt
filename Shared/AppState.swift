//
//  AppState.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class AppState: {

}

protocol TasksListAppState {

    var tasksSubject: PassthroughSubject<[TaskDTO], Never>
    
}
