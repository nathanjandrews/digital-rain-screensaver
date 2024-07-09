//
//  Overlay.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import AppKit

class Overlay {
    private let x: Double
    private let dimensions: ScreenDimensions
    private let overlayView = NSView()
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x
        self.dimensions = dimensions
        
        self.overlayView.wantsLayer = true
        self.overlayView.layer?.backgroundColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1) // red
        self.overlayView.frame = NSMakeRect(x + Preferences.shared.FONT_SIZE / 2, 0, Preferences.shared.FONT_SIZE, dimensions.height)
    }
    
    var view: NSView {
        get {
            return self.overlayView
        }
    }
}
