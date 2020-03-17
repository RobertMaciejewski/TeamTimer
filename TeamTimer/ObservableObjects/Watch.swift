//
//  Watch.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import Combine
import Foundation

class Watch: ObservableObject {
    static let refreshRate: TimeInterval = 0.1

    let id: Int

    @Published var timer: TimerDevice? {
        didSet { self.started = self.timer != nil }
    }
    @Published var text: String = ""
    @Published var targetTimeText: String = ""
    @Published var targetTime: TimeInterval? = nil
    @Published var started: Bool = false

    private var targetTimeConfig = CurrentValueSubject<TimeInterval?, Never>(nil)
    private var timeConverter = TimeConverter()
    private var cancellables: [AnyCancellable] = []

    init(id: Int) {
        self.id = id
        self.bindTextToTime().store(in: &self.cancellables)
        self.formatTime().store(in: &self.cancellables)
    }

    func start() {
        let timer: TimerDevice
        if let target = self.targetTime {
            timer = TimerDevice(target: Date() + target, direction: .down)
        } else {
            timer = TimerDevice(direction: .up)
        }
        timer.start()
        self.timer = timer
    }

    func commitTargetTime() {
        self.targetTime = self.targetTimeConfig.value
    }

    private func bindTextToTime() -> AnyCancellable {
        self.$targetTimeText
            .removeDuplicates()
            .map { self.timeConverter.decode(text: $0) }
            .subscribe(self.targetTimeConfig)
    }

    private func formatTime() -> AnyCancellable {
        self.$timer
            .map { $0?.$time.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher() }
            .switchToLatest()
            .map { self.timeConverter.encode(value: $0) }
            .sink { self.text = $0 ?? "" }
    }
}

extension Watch {
    private class TimeConverter {
        static let formatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()

        func encode(value: TimeInterval?) -> String? {
            if let value = value {
                return TimeConverter.formatter.string(from: value)
            } else {
                return nil
            }
        }

        func decode(text: String) -> TimeInterval? {
            if text.range(of: #"^[\d:]*$"#, options: .regularExpression) == nil || text.isEmpty { return nil }
            var seconds = ""
            var minutes = ""
            var hours = ""
            text.split(separator: ":").reversed().enumerated().forEach {
                switch $0.offset {
                case 0: seconds = String($0.element)
                case 1: minutes = String($0.element)
                default: hours = String($0.element)
                }
            }
            var total: TimeInterval = Double(seconds) ?? 0
            total += (Double(minutes) ?? 0) * 60
            total += (Double(hours) ?? 0) * 60 * 60
            return total
        }
    }
}
