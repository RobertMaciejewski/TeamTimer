//
//  AddButton.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import SwiftUI

struct AddButton: View {
    @EnvironmentObject var viewConfig: ViewConfig

    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            Text("+ Add")
                .font(.system(size: self.viewConfig.fontSize))
                .padding()
                .frame(maxWidth: .infinity, minHeight: 80)
                .contentShape(Rectangle())
        }
            .buttonStyle(PlainButtonStyle())
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(action: {})
            .environmentObject(ViewConfig())
    }
}
