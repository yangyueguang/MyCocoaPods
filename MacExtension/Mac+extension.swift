//
//  Mac+extension.swift
//  WeChatPlugin
//
//  Created by Chao Xue 薛超 on 2019/4/17.
//  Copyright © 2019 Freedom. All rights reserved.
//
import Cocoa
import Foundation
extension NSMenu {
    func addItems(_ subItems: [NSMenuItem]) {
        for item in subItems {
            addItem(item)
        }
    }
}

extension NSMenuItem {
    convenience init(title: String, action selector: Selector, target: AnyObject, keyEquivalent key: String?, state: Bool) {
        self.init(title: title, action: selector, keyEquivalent: key ?? "")
        self.target = target
        self.state = NSControl.StateValue(rawValue: state ? 1 : 0)
    }
}

extension NSButton {
    var isOn: Bool {
        set {state = NSControl.StateValue(newValue ? 1 : 0)}
        get {return state.rawValue == 1}
    }
    convenience public init(f: NSRect, t: String, tar: AnyObject, a: Selector, type: ButtonType? = nil) {
        self.init(frame: f)
        title = t
        target = tar
        action = a
        if let ty = type {setButtonType(ty)}
    }
}

extension NSTextField {
    convenience public init(value: String) {
        self.init(frame: NSRect(x: 10, y: 10, width: 200, height: 17))
        stringValue = stringValue
        isBezeled = false
        drawsBackground = false
        isEditable = false
        isSelectable = false
    }
}

extension NSAlert {
    convenience public init(title: String, message: String, info: String) {
        self.init()
        addButton(withTitle: title)
        messageText = message
        informativeText = info
    }
}

public extension NSWindowController {
    public func show() {
        showWindow(self)
        window?.center()
        window?.makeKey()
    }
}
