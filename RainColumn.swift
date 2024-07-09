//
//  RainColumn.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import AppKit

class RainColumn {
    
    private let x: Double;
    private let dimensions: ScreenDimensions
    private let textView = NSTextView()
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x;
        self.dimensions = dimensions
        
        self.textView.string = self.generateTextColumn()
        self.textView.font = NSFont.monospacedSystemFont(ofSize: Preferences.shared.FONT_SIZE, weight: .regular)
        self.textView.backgroundColor = .black
        
        self.textView.frame = NSMakeRect(x, 0, Preferences.shared.FONT_SIZE, dimensions.height)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func generateTextColumn() -> String {
        return String((0..<self.numCharactersInColumn).map {_ in
            Preferences.shared.CHARACTER_SEED_STRING.randomElement()!
        })
    }
    
    var numCharactersInColumn: Int {
        get {
            return Int(self.dimensions.height / Preferences.shared.FONT_SIZE)
        }
        
    }
    
    var subview: NSView {
        get {
            return self.textView
        }
    }
}
