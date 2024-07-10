//
//  Text.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import AppKit

class Text {
    private let FRAMES_BETWEEN_SWAP = 5
    private var framesWaited = 0;
    
    private let x: Double;
    private let dimensions: ScreenDimensions
    private let textView = NSTextView()
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x
        self.dimensions = dimensions
        
        self.textView.wantsLayer = true
        self.textView.string = self.generateTextColumn()
        self.textView.font = NSFont.monospacedSystemFont(ofSize: Preferences.shared.FONT_SIZE, weight: .regular)
        self.textView.alignment = .center
        self.textView.textColor = Preferences.shared.TEXT_COLOR
        self.textView.backgroundColor = .clear
        self.textView.frame = NSMakeRect(x, 0, Preferences.shared.FONT_SIZE, dimensions.height)
    }
    
    func animateOneFrame() {
        if (!Preferences.shared.DO_CHARACTER_SWAP) {
            return
        }
        
        self.framesWaited += 1
        if (self.framesWaited == self.FRAMES_BETWEEN_SWAP) {
            self.swapCharacter()
            self.framesWaited = 0
        }
    }
    
    func draw() {}
    
    func swapTextColumn() {
        self.textView.string = self.generateTextColumn()
    }
    
    private func swapCharacter() {
        let randomIndex = Int.random(in: 0..<self.textView.string.count)
        self.textView.insertText(self.generateRandomCharacter(), replacementRange: NSRange(location: randomIndex, length: 1))
    }
    
    private func generateTextColumn() -> String {
        return String((0..<self.numCharactersInColumn).map {_ in
            Preferences.shared.CHARACTER_SEED_STRING.randomElement()!
        })
    }
    
    private func generateRandomCharacter() -> String {
        return String(Preferences.shared.CHARACTER_SEED_STRING.randomElement()!)
    }
    
    var numCharactersInColumn: Int {
        get {
            return Int(self.dimensions.height / Preferences.shared.FONT_SIZE)
        }
    }
    
    var view: NSView {
        get {
            return self.textView
        }
    }
}
