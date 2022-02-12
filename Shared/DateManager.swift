//
//  DateManager.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

final class DateManager {

    var timerPublisher: AnyPublisher<String?, Never>?

    private var timerSubject = PassthroughSubject<String?, Never>()
    private var lastSynchDate = Date()

    private func getTime() -> String {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: lastSynchDate, to: Date())
        let minutes = String(diffComponents.minute ?? 0)
        let seconds = String(diffComponents.second ?? 0)

        var value = ""
        if diffComponents.minute ?? 0 == 0 &&
            diffComponents.second ?? 0 < 10 {
            value = "now"
        } else if diffComponents.minute ?? 0 == 0 {
            value = String(seconds) + " sec"
        } else if diffComponents.minute ?? 0 < 2 {
            value = String(minutes) + " : " + String(seconds)
        } else {
            value = String(minutes) + " min"
        }

        return "Last sync: " + value
    }

    func startSyncTimer() {
        timerPublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
            .autoconnect()
            .map { [weak self] _ in self?.getTime() }
            .eraseToAnyPublisher()
    }

    func updateDate() {
        lastSynchDate = Date()
    }

}
