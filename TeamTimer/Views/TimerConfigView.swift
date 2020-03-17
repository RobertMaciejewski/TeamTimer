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
        LargeTextFieldView(
            stringValue: self.$watch.targetTimeText,
            placeholderString: "Add New Timer",
            onCommit: {
                self.watch.commitTargetTime()
                self.watch.start()
            }
        )
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .textFieldStyle(PlainTextFieldStyle())
            .font(.system(size: self.viewConfig.fontSizes.config))
            .contentShape(Rectangle())
    }
}

struct TimerConfigView_Previews: PreviewProvider {
    static var previews: some View {
        return TimerConfigView(watch: Watch(id: 0))
            .environmentObject(ViewConfig())
    }
}
