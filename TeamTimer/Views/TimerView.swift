//
//  TimerView.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var viewConfig: ViewConfig
    @ObservedObject var watch: Watch

    var body: some View {
        Text(self.watch.text)
            .font(.system(size: self.viewConfig.fontSize))
            .padding()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var watch: Watch {
        let watch = Watch(id: 0)
        watch.start()
        return watch
    }
    static var previews: some View {
        TimerView(watch: self.watch)
            .environmentObject(ViewConfig())
            .frame(width: 400, height: 300)
    }
}
