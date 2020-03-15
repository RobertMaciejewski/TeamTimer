//
//  World.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/14/20.
//

import Combine

class World: ObservableObject {
    @Published var watches: [Watch] = []

    private var addingWatchRequested = PassthroughSubject<Void, Never>()
    private var cancellables: [AnyCancellable] = []

    init() {
        self.addingWatchRequested
            .combineLatest(self.$watches) { _, watches in watches + [Watch(id: watches.count)] }
            .sink { self.watches = $0 }
            .store(in: &self.cancellables)
    }

    func addWatch() {
        self.addingWatchRequested.send()
    }
}
