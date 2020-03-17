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
    @State var stopAlerting: Bool = false

    var onRemoveWatch: ((Watch) -> Void)?

    private var alerting: Bool { self.watch.finished && !self.stopAlerting }
    private var showRemoveButton: Bool { self.watch.finished && !self.stopAlerting || self.watch.suspended }

    var body: some View {
        Button(action: self.onClick) {
            HStack {
                self.removeButton
                self.text
            }
        }
            .buttonStyle(PlainButtonStyle())
    }

    private var removeButton: some View {
        Button(action: self.removeWatch) {
            Text("X")
                .font(.system(size: 18))
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
            .buttonStyle(PlainButtonStyle())
            .background(Color.black.opacity(0.3))
            .cornerRadius(22)
            .padding()
    }

    private var text: some View {
        Text(self.textString)
            .font(.system(size: self.viewConfig.fontSizes.timer))
            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
            .padding()
            .foregroundColor(self.alerting ? Color.red : Color.black)
            .animation(nil)
            .scaleEffect(self.alerting ? 2 : 1)
            .animation(self.animation)
            .contentShape(Rectangle())
    }

    private var animation: Animation? {
        if !self.alerting { return Animation.default }
        return Animation.spring(response: 0.15, dampingFraction: 0.1).repeatForever(autoreverses: false)
    }

    private var textString: String {
        if !self.watch.finished { return (self.watch.suspended ? "(S) " : "") + self.watch.text }
        if self.stopAlerting { return "Finished" }
        return self.toggler.value ? "Beep!!" : self.watch.text
    }

    private func removeWatch() {
        self.onRemoveWatch?(self.watch)
    }

    private func onClick() {
        if !self.watch.started { return }
        if !self.watch.finished {
            self.watch.interrupt()
        } else if !self.stopAlerting {
            self.stopAlerting = true
        }
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
