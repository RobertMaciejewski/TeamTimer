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

    @Published var finished: Bool = false

    let time = CurrentValueSubject<TimeInterval, Never>(0)

    let target: Date
    let direction: Direction

    private var cancellables: [AnyCancellable] = []

    init(target: Date = Date(), direction: Direction) {
        self.target = target
        self.direction = direction
        self.watchCompletion().store(in: &self.cancellables)
    }

    func start() {
        Timer.publish(every: Watch.refreshRate, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] _ in self }
            .filter { $0 != nil }
            .map { $0!.distance() }
            .removeDuplicates()
            .prefix { $0 >= 0 }
            .sink { [weak self] in self?.send($0) }
            .store(in: &self.cancellables)
    }

    private func watchCompletion() -> AnyCancellable {
        self.time.sink(receiveCompletion: { _ in self.finished = true }, receiveValue: { _ in })
    }

    private func send(_ time: TimeInterval) {
        self.time.send(time)
        if time <= 0 { self.time.send(completion: .finished) }
    }

    private func distance() -> TimeInterval {
        switch self.direction {
        case .up: return self.target.distance(to: Date()).rounded(.down)
        case .down: return Date().distance(to: self.target).rounded(.up)
        }
    }
}
