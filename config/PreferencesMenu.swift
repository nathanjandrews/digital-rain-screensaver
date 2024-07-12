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
    let seedStringTextField = NSTextField()
    let fontSizeSlider = NSSlider()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(window: NSWindow(contentRect: NSMakeRect(0, 0, 400, 300), styleMask: .closable, backing: .buffered, defer: true))
        
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        
       
        mainStack.addView(self.createSeedStringStack(), in: .leading)
        mainStack.addView(self.createfontSizeSliderStack(), in: .leading)
        mainStack.addView(self.createColorWellStack(), in: .leading)
        mainStack.addView(self.createButtonStack(), in: .leading)
        mainStack.spacing = 25
        
        
        mainStack.edgeInsets.top = 50
        mainStack.edgeInsets.bottom = 50.0
        
        self.window?.contentView = mainStack
        
        self.loadPreferences()
    }
    
    private func savePreferences() {
        Preferences.shared.TEXT_COLOR = textColorWell.color
        Preferences.shared.TEXT_HIGHLIGHT_COLOR = highlightColorWell.color
        Preferences.shared.BACKGROUND_COLOR = backgroundColorWell.color
        Preferences.shared.CHARACTER_SEED_STRING = seedStringTextField.stringValue
        Preferences.shared.FONT_SIZE = fontSizeSlider.doubleValue
    }
    
    private func loadPreferences() {
        textColorWell.color = Preferences.shared.TEXT_COLOR
        highlightColorWell.color = Preferences.shared.TEXT_HIGHLIGHT_COLOR
        backgroundColorWell.color = Preferences.shared.BACKGROUND_COLOR
        seedStringTextField.stringValue = Preferences.shared.CHARACTER_SEED_STRING
        fontSizeSlider.doubleValue = Preferences.shared.FONT_SIZE
    }
    
    private func createfontSizeSliderStack() -> NSStackView {
        let stack = NSStackView()
        stack.orientation = .vertical
        
        self.fontSizeSlider.minValue = 20
        self.fontSizeSlider.maxValue = 80
        self.fontSizeSlider.altIncrementValue = 5
        self.fontSizeSlider.numberOfTickMarks = Int((self.fontSizeSlider.maxValue - self.fontSizeSlider.minValue) / self.fontSizeSlider.altIncrementValue)
        self.fontSizeSlider.sliderType = .linear
        self.fontSizeSlider.allowsTickMarkValuesOnly = true
        
        stack.addView(self.createLabel(text: "Font Size"), in: .leading)
        stack.addView(self.fontSizeSlider, in: .leading)
        
        NSLayoutConstraint.activate([
            self.fontSizeSlider.widthAnchor.constraint(equalToConstant: 320),
        ])
        
        return stack
    }
    
    private func createSeedStringStack() -> NSStackView {
        let stack = NSStackView()
        stack.orientation = .vertical
        
        self.seedStringTextField.isEditable = true
        self.seedStringTextField.isBezeled = true
        self.seedStringTextField.bezelStyle = .roundedBezel
        self.seedStringTextField.placeholderString = "Type some characters..."

        stack.addView(self.createLabel(text: "Seed String:"), in: .leading)
        stack.addView(self.seedStringTextField, in: .leading)
        
        NSLayoutConstraint.activate([
            self.seedStringTextField.widthAnchor.constraint(equalToConstant: 320),
        ])
        
        return stack
    }
    
    private func createColorWellStack() -> NSStackView {
        let labelStack = NSStackView()
        labelStack.orientation = .vertical
        labelStack.spacing = 15
        labelStack.addView(self.createLabel(text: "Text Color"), in: .top)
        labelStack.addView(self.createLabel(text: "Highlight Text Color"), in: .top)
        labelStack.addView(self.createLabel(text: "Background Color"), in: .top)
        
        let colorWellStack = NSStackView()
        colorWellStack.orientation = .vertical
        colorWellStack.addView(self.textColorWell, in: .top)
        colorWellStack.addView(self.highlightColorWell, in: .top)
        colorWellStack.addView(self.backgroundColorWell, in: .top)
    
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 20
        stack.addView(labelStack, in: .leading)
        stack.addView(colorWellStack, in: .leading)
        
        return stack
    }
    

    private func createButtonStack() -> NSStackView {
        let stack = NSStackView()
        stack.orientation = .horizontal
        
        let okButton = self.createButton(title: "OK", keyEquivalent: "\r", action: #selector(self.performOk))
        stack.addView(okButton, in: .trailing)
        
        let resetButton = self.createButton(title: "Reset", keyEquivalent: "r", action: #selector(self.performReset))
        stack.addView(resetButton, in: .trailing)
        
        let cancelButton = self.createButton(title: "Cancel", keyEquivalent: "\u{001B}", action: #selector(self.performCancel))
        stack.addView(cancelButton, in: .trailing)
        
        return stack
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
    }
    
    @objc func performCancel() {
        self.window?.sheetParent?.endSheet(self.window!)
    }
    
    @objc func performOk() {
        self.savePreferences()
        self.window?.sheetParent?.endSheet(self.window!)
    }
}
