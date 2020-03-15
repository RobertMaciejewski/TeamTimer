//
//  TimerConfig.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import SwiftUI

struct TimerConfigView: View {
    @EnvironmentObject var viewConfig: ViewConfig
    @ObservedObject var watch: Watch

    var body: some View {
        VStack {
            TextField(
                "target", text: self.$watch.targetTimeText,
                onEditingChanged: { editing in
                    if !editing {
                        self.watch.commitTargetTime()
                    }
                },
                onCommit: { self.watch.start() }
            )
                .frame(maxWidth: .infinity, idealHeight: 200)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: self.viewConfig.fontSize))
                .padding()
        }
    }
}

struct TimerConfigView_Previews: PreviewProvider {
    static var previews: some View {
        return TimerConfigView(watch: Watch(id: 0))
            .environmentObject(ViewConfig())
    }
}
