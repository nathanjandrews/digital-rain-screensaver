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
    
    private var gradientLayer = CAGradientLayer()
    private var overlayHeight: Double
    private var y: Double
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x
        self.dimensions = dimensions
        
        self.overlayHeight = dimensions.height / 2
        self.y = dimensions.height
        
        self.overlayView.wantsLayer = true
        self.overlayView.layer = CALayer()
        
        // The cover layer is the opaque rectangle that hides all characters that are not within the bounds
        // of the gradient layer
        let coverLayer = CALayer()
        coverLayer.backgroundColor = Preferences.shared.BACKGROUND_COLOR.cgColor
        coverLayer.frame = CGRect(x: self.x, y: 0, width: Preferences.shared.FONT_SIZE, height: self.dimensions.height)
        self.overlayView.layer?.addSublayer(coverLayer)
        
        self.gradientLayer.backgroundColor = Preferences.shared.TEXT_COLOR.cgColor
        self.gradientLayer.colors = [
                        Preferences.shared.BACKGROUND_COLOR.cgColor,
                        NSColor.clear.cgColor,
                        Preferences.shared.BACKGROUND_COLOR.cgColor,
                    ]
        self.gradientLayer.locations = [
                    0.1,
                    0.8,
                    0.9
                ]
        self.gradientLayer.frame = CGRect(x: self.x, y: self.y, width: Preferences.shared.FONT_SIZE * 2, height: self.overlayHeight)
        self.overlayView.layer?.addSublayer(self.gradientLayer)
        
        self.overlayView.layer?.compositingFilter = CIFilter(name: "CISourceInCompositing")
    }
    
    func animateOneFrame() {
        y -= Preferences.shared.BASE_RAIN_SPEED
        if (y <= -self.overlayHeight) {
            y = self.dimensions.height + self.overlayHeight
        }
    }
    
    func draw() {
        // update the position of the overlay without animating between positions.
        // this fixes the flickering that happens when we reset the overlay to the
        // top of the screen.
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.gradientLayer.position = CGPoint(x: self.x, y: self.y)
        CATransaction.commit()
    }
    
    var view: NSView {
        get {
            return self.overlayView
        }
    }
}
