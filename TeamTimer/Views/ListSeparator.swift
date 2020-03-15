//
//  ListSeparator.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import SwiftUI

struct ListSeparator: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .foregroundColor(Color.black.opacity(0.2))
    }
}

struct ListSeparator_Previews: PreviewProvider {
    static var previews: some View {
        ListSeparator()
    }
}
