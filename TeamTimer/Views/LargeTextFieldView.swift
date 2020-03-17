//
//  LargeTextFieldView.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/17/20.
//

import SwiftUI

struct LargeTextFieldView: NSViewRepresentable {
    typealias NSViewType = LargeTextField

    @EnvironmentObject var viewConfig: ViewConfig
    @Binding var stringValue: String
    var placeholderString: String?
    var onCommit: (() -> Void)?

    func makeNSView(context: NSViewRepresentableContext<LargeTextFieldView>) -> LargeTextField {
        let field = LargeTextField(frame: .zero)
        field.instantiateContent()
        return field
    }

    func updateNSView(_ nsView: LargeTextField, context: NSViewRepresentableContext<LargeTextFieldView>) {
        nsView.configure(self.viewConfig)
        nsView.placeholderString = self.placeholderString
        nsView.onEditingChanged = { _ in self.stringValue = nsView.stringValue }
        nsView.onCommit = self.onCommit
    }
}

struct LargeTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        var stringValue: String = ""
        let stringValueBinding = Binding(
            get: { stringValue },
            set: { stringValue = $0 }
        )
        return LargeTextFieldView(stringValue: stringValueBinding)
    }
}
