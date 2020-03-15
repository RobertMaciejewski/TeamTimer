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
            TimerView(watch: self.watch)
        } else {
            TimerConfigView(watch: self.watch)
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        return WatchView(watch: Watch(id: 0))
            .frame(width: 400, height: 200)
            .environmentObject(ViewConfig())
    }
}
