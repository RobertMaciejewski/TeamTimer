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
    @ObservedObject var toggler = Toggler(duration: 0.7)

    var body: some View {
        Text(self.watch.finished && self.toggler.value ? "Beep!!" : self.watch.text)
            .font(.system(size: self.viewConfig.fontSizes.timer))
            .frame(minWidth: 300, minHeight: 60)
            .padding()
            .foregroundColor(self.watch.finished ? Color.red : Color.black)
            .animation(nil)
            .scaleEffect(self.watch.finished ? 2 : 1)
            .animation(Animation.spring(response: 0.15, dampingFraction: 0.1).repeatForever(autoreverses: false))
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
            .frame(width: 200)
    }
}
