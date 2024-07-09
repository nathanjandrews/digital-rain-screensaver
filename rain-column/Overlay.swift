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
        
        self.overlayHeight = dimensions.height
        self.y = dimensions.height - 1.5 * self.overlayHeight
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Preferences.shared.BACKGROUND_COLOR.cgColor,
            NSColor.clear.cgColor,
            Preferences.shared.BACKGROUND_COLOR.cgColor,
        ]
        gradientLayer.locations = [
            0.4,
            0.5,
            0.6
        ]
        gradientLayer.frame = CGRect(x: self.x, y: self.y, width: Preferences.shared.FONT_SIZE, height: self.overlayHeight)
        // we don't need to set overlayView.wantsLayer because we are explicitly setting the layer here
        self.overlayView.layer = gradientLayer
        
        self.overlayView.frame = NSMakeRect(self.x, self.y, Preferences.shared.FONT_SIZE, self.overlayHeight)
    }
    
    func animateOneFrame() {
        y -= Preferences.shared.BASE_RAIN_SPEED
        if (y <= -self.overlayHeight) {
            y = dimensions.height
        }
    }
    
    func draw() {
        self.overlayView.frame = NSMakeRect(self.x, self.y, Preferences.shared.FONT_SIZE, self.overlayHeight)
    }
    
    var view: NSView {
        get {
            return self.overlayView
        }
    }
}
