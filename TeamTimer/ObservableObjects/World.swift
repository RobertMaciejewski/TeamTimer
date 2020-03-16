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
    @Published var watches: [Watch] = []
    @Published var hasUnstartedWatch: Bool = false

    private var addingWatchRequested = PassthroughSubject<Void, Never>()
    private var cancellables: [AnyCancellable] = []

    init() {
        self.manageAddingWatch().store(in: &self.cancellables)
        self.watchUnstartedWatches().store(in: &self.cancellables)
        self.$hasUnstartedWatch.sink { if !$0 { self.addWatch() } }.store(in: &self.cancellables)
    }

    func addWatch() {
        self.addingWatchRequested.send()
    }

    private func watchUnstartedWatches() -> AnyCancellable {
        self.$watches
            .map { combine(sequence: $0.map { $0.$started }) }
            .switchToLatest()
            .map { !$0.allSatisfy { $0 } }
            .sink { [weak self] in self?.hasUnstartedWatch = $0 }
    }

    private func manageAddingWatch() -> AnyCancellable {
        self.addingWatchRequested
            .combineLatest(self.$watches) { _, watches in watches + [Watch(id: watches.count)] }
            .sink { self.watches = $0 }
    }
}
