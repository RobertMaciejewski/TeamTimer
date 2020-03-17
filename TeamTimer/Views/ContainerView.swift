//
//  ContentView.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/14/20.
//

import SwiftUI

struct ContainerView: View {
    @ObservedObject var world: World

    var body: some View {
        VStack(spacing: 0) {
            ForEach(self.world.watches, id: \.id) { watch in
                WatchView(watch: watch, onRemoveWatch: self.removeWatch)
            }
        }
            .frame(minWidth: 400)
    }

    private func addWatch() {
        self.world.addWatch()
    }

    private func removeWatch(_ watch: Watch) {
        self.world.remove(watch: watch)
    }
}

struct ContainerView_Previews: PreviewProvider {
    private static var world: World {
        let world = World()
        world.addWatch()
        world.watches.forEach { $0.start() }
        return world
    }
    static var previews: some View {
        ContainerView(world: self.world)
            .environmentObject(ViewConfig())
    }
}
