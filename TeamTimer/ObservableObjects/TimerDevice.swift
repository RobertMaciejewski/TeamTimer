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

    @Published var suspended: Bool = false {
        didSet { self.suspendedAt.send(self.suspended ? Date() : nil) }
    }
    @Published var finished: Bool = false
    @Published var suspension: TimeInterval = 0

    let time = CurrentValueSubject<TimeInterval, Never>(0)

    let target: Date
    let direction: Direction

    private let suspendedAt = CurrentValueSubject<Date?, Never>(nil)
    private var started = false

    private var cancellables: [AnyCancellable] = []

    init(target: Date = Date(), direction: Direction) {
        self.target = target
        self.direction = direction
        self.watchCompletion().store(in: &self.cancellables)

        self.suspendedAt
            .scan((nil, nil)) { ($0.1, $1) }
            .filter { $0.0 != nil && $0.1 == nil }
            .map { $0.0!.distance(to: Date()) }
            .sink { [weak self] in self?.suspension += $0 }
            .store(in: &self.cancellables)
    }

    func start() {
        if self.started { return }
        self.started = true
        Timer.publish(every: Watch.refreshRate, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global())
            .map { [weak self] _ in self }
            .filter { $0 != nil && !$0!.suspended }
            .map { $0!.distance() }
            .removeDuplicates()
            .prefix { $0 >= 0 }
            .sink { [weak self] in self?.send($0) }
            .store(in: &self.cancellables)
    }

    func interrupt() {
        self.suspended = !self.suspended
    }

    private func watchCompletion() -> AnyCancellable {
        self.time.sink(receiveCompletion: { _ in self.finished = true }, receiveValue: { _ in })
    }

    private func send(_ time: TimeInterval) {
        self.time.send(time)
        if time <= 0 {
            self.time.send(completion: .finished)
        }
    }

    private func distance() -> TimeInterval {
        switch self.direction {
        case .up: return (self.target.distance(to: Date()) - self.suspension).rounded(.down)
        case .down: return (Date().distance(to: self.target) + self.suspension).rounded(.up)
        }
    }
}
