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
    
    private var overlayHeight: Double
    private var y: Double
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x
        self.dimensions = dimensions
        
        self.overlayHeight = dimensions.height / 4
        self.y = dimensions.height - self.overlayHeight
        
        
        self.overlayView.wantsLayer = true
        self.overlayView.layer?.backgroundColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1) // red
        self.overlayView.frame = NSMakeRect(self.x + Preferences.shared.FONT_SIZE / 2, self.y, Preferences.shared.FONT_SIZE, self.overlayHeight)
    }
    
    func animateOneFrame() {
        y -= Preferences.shared.BASE_RAIN_SPEED
        if (y <= -self.overlayHeight) {
            y = dimensions.height
        }
    }
    
    func draw() {
        self.overlayView.frame = NSMakeRect(self.x + Preferences.shared.FONT_SIZE / 2, self.y, Preferences.shared.FONT_SIZE, self.overlayHeight)
    }
    
    var view: NSView {
        get {
            return self.overlayView
        }
    }
}
