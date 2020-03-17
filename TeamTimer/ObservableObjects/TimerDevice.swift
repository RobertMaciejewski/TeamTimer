//
//  Timer.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/16/20.
//

import Combine
import Foundation

class TimerDevice: ObservableObject {
    enum Direction {
        case up, down
    }

    @Published var time: TimeInterval = 0

    let target: Date
    let direction: Direction

    private var cancellables: [AnyCancellable] = []

    init(target: Date = Date(), direction: Direction) {
        self.target = target
        self.direction = direction
    }

    func start() {
        Timer.publish(every: Watch.refreshRate, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] _ in self }
            .filter { $0 != nil }
            .map { $0!.distance() }
            .removeDuplicates()
            .sink { [weak self] in self?.time = $0 }
            .store(in: &self.cancellables)
    }

    private func distance() -> TimeInterval {
        self.target.distance(to: Date()).rounded(.down)
    }
}
