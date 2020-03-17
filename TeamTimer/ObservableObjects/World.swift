//
//  World.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/14/20.
//

import Combine

private func combine<P: Publisher, S, F>(sequence: [P]) -> AnyPublisher<[S], F> where P.Output == S, P.Failure == F {
    let seed: AnyPublisher<[S], F> = Just<[S]>([]).setFailureType(to: F.self).eraseToAnyPublisher()
    return sequence.reduce(seed) { memo, publisher in memo.combineLatest(publisher) { $0 + [$1] }.eraseToAnyPublisher() }
}

class World: ObservableObject {
    @Published var watchRepo: [Int: Watch] = [:]
    @Published var hasUnstartedWatch: Bool = false

    var watches: [Watch] { self.watchRepo.values.sorted { $0.id < $1.id } }
    var watchesPublisher: AnyPublisher<[Watch], Never> {
        self.$watchRepo.map { $0.values.sorted { $0.id < $1.id } }.eraseToAnyPublisher()
    }

    private var addingWatchRequested = PassthroughSubject<Void, Never>()
    private var removingWatchRequested = PassthroughSubject<Watch, Never>()
    private var cancellables: [AnyCancellable] = []

    init() {
        self.manageAddingWatch().store(in: &self.cancellables)
        self.manageRemovingWatch().store(in: &self.cancellables)
        self.watchUnstartedWatches().store(in: &self.cancellables)
        self.$hasUnstartedWatch.sink { if !$0 { self.addWatch() } }.store(in: &self.cancellables)
    }

    func addWatch() {
        self.addingWatchRequested.send()
    }

    func remove(watch: Watch) {
        self.removingWatchRequested.send(watch)
    }

    private func watchUnstartedWatches() -> AnyCancellable {
        self.watchesPublisher
            .map { combine(sequence: $0.map { $0.$started }) }
            .switchToLatest()
            .map { !$0.allSatisfy { $0 } }
            .sink { [weak self] in self?.hasUnstartedWatch = $0 }
    }

    private func manageAddingWatch() -> AnyCancellable {
        self.addingWatchRequested
            .map { 1 }
            .scan(0) { $0 + $1 }
            .sink { self.watchRepo[$0] = Watch(id: $0) }
    }

    private func manageRemovingWatch() -> AnyCancellable {
        self.removingWatchRequested
            .sink { self.watchRepo.removeValue(forKey: $0.id) }
    }
}
