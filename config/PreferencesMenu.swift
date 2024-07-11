//
//  PreferencesMenu.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/11/24.
//

import Foundation
import AppKit

class DigitalRainPreferencesController : NSWindowController, NSWindowDelegate {
    
    let textColorWell = NSColorWell(style: .minimal)
    let highlightColorWell = NSColorWell(style: .minimal)
    let backgroundColorWell = NSColorWell(style: .minimal)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(window: NSWindow(contentRect: NSMakeRect(0, 0, 320, 200), styleMask: .closable, backing: .buffered, defer: true))
        
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        
        mainStack.addView(self.createColorWellStack(colorWell: self.textColorWell, label: "Text Color"), in: .trailing)
        mainStack.addView(self.createColorWellStack(colorWell: self.highlightColorWell, label: "Highlight Text Color"), in: .trailing)
        mainStack.addView(self.createColorWellStack(colorWell: self.backgroundColorWell, label: "Background Color"), in: .trailing)
        
        let okButton = self.createButton(title: "OK", keyEquivalent: "\r", action: #selector(self.performOk))
        mainStack.addView(okButton, in: .trailing)
        
        let cancelButton = self.createButton(title: "Cancel", keyEquivalent: "\u{001B}", action: #selector(self.performCancel))
        mainStack.addView(cancelButton, in: .trailing)
        
        let resetButton = self.createButton(title: "Reset", keyEquivalent: "r", action: #selector(self.performReset))
        mainStack.addView(resetButton, in: .trailing)
        
        self.window?.contentView = mainStack
        
        self.loadPreferences()
    }
    
    private func savePreferences() {
        Preferences.shared.TEXT_COLOR = textColorWell.color
        Preferences.shared.TEXT_HIGHLIGHT_COLOR = highlightColorWell.color
        Preferences.shared.BACKGROUND_COLOR = backgroundColorWell.color
    }
    
    private func loadPreferences() {
        textColorWell.color = Preferences.shared.TEXT_COLOR
        highlightColorWell.color = Preferences.shared.TEXT_HIGHLIGHT_COLOR
        backgroundColorWell.color = Preferences.shared.BACKGROUND_COLOR
    }
    
    private func createColorWellStack(colorWell: NSColorWell, label: String) -> NSStackView {
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.addView(self.createLabel(text: label), in: .leading)
        stackView.addView(colorWell, in: .trailing)
        return stackView
    }
    
    private func createLabel(text: String) -> NSTextField {
        let textField = NSTextField()
        textField.stringValue = text
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        return textField
    }
    
    private func createButton(title: String, keyEquivalent: String, action: Selector) -> NSButton {
        let button = NSButton()
        button.title = title
        button.keyEquivalent = keyEquivalent
        button.bezelStyle = .push
        button.action = action
        
        return button
    }
    
    
    
    
    @objc func performReset() {
        Preferences.shared.reset()
        self.loadPreferences()
        self.window?.sheetParent?.endSheet(self.window!)
    }
    
    @objc func performCancel() {
        self.window?.sheetParent?.endSheet(self.window!)
    }
    
    @objc func performOk() {
        self.savePreferences()
        self.window?.sheetParent?.endSheet(self.window!)
    }
}
