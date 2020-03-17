//
//  WatchView.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import SwiftUI

struct WatchView: View {
    @ObservedObject var watch: Watch

    @ViewBuilder
    var body: some View {
        if self.watch.started {
            self.timerView
        } else {
            self.timerConfigView
        }
    }

    private var timerView: some View {
        VStack(spacing: 0.0) {
            TimerView(watch: self.watch)
            ListSeparator()
        }
    }

    private var timerConfigView: some View {
        TimerConfigView(watch: self.watch)
    }
}

struct WatchView_Previews: PreviewProvider {
    static var watch: Watch {
        let watch = Watch(id: 0)
        watch.start()
        return watch
    }
    static var previews: some View {
        return WatchView(watch: self.watch)
            .environmentObject(ViewConfig())
    }
}
