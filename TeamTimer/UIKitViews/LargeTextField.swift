//
//  LargeTextField.swift
//  TeamTimer
//
//  Created by Hiroki Arai on 3/16/20.
//

import AppKit

class LargeTextField: NSView {
    var onEditingChanged: ((Bool) -> Void)?
    var onCommit: (() -> Void)?

    var stringValue: String { self.content.textField.stringValue }
    var placeholderString: String? {
        get { self.content.textField.placeholderString }
        set { self.content.textField.placeholderString = newValue }
    }

    private var editing: Bool = false

    @IBOutlet private var content: LargeTextFieldContent!

    func instantiateContent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        if !NSNib(nibNamed: "LargeTextField", bundle: nil)!.instantiate(withOwner: self, topLevelObjects: nil) {
            fatalError("Failed to instantiate LargeTextField")
        }
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.content)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44),
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.content, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.content, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: self.content, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: self.content, attribute: .left, multiplier: 1, constant: 0),
        ])
    }

    func configure(_ viewConfig: ViewConfig) {
        self.content.textField.delegate = self
        self.content.textField.font = .systemFont(ofSize: viewConfig.fontSizes.config)
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        self.content.textField
    }
}

class LargeTextFieldContent: NSView {
    @IBOutlet weak var textField: NSTextField!
}

extension LargeTextField: NSTextFieldDelegate {
    func controlTextDidBeginEditing(_ obj: Notification) {
        self.editing = true
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        self.editing = false
        self.onCommit?()
    }

    func controlTextDidChange(_ obj: Notification) {
        self.onEditingChanged?(self.editing)
    }
}
