//
//  ViewConfig.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/15/20.
//

import Foundation
import Combine

class ViewConfig: ObservableObject {
    struct FontSizes {
        var timer: CGFloat = 32
        var config: CGFloat = 24
    }

    @Published var fontSizes = FontSizes()
}
