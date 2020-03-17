//
//  Toggler.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/17/20.
//

import Combine
import Foundation

class Toggler: ObservableObject {
    @Published var value: Bool = false

    let duration: TimeInterval

    private var cancellables: [AnyCancellable] = []

    init(duration: TimeInterval) {
        self.duration = duration

        Timer.publish(every: self.duration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.value.toggle() }
            .store(in: &self.cancellables)
    }
}
