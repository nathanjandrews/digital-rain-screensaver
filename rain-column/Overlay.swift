//
//  Overlay.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import AppKit

class Overlay {
    private var x: Double
    private let dimensions: ScreenDimensions
    private let overlayView = NSView()
    
    private var gradientLayer = CAGradientLayer()
    private var maskLayer = CAShapeLayer()
    private var overlayHeight: Double = 0
    private var y: Double = 0
    private var delta = Preferences.shared.BASE_RAIN_SPEED
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x
        self.dimensions = dimensions
        
        self.overlayView.wantsLayer = true
        self.overlayView.layer = CALayer()
        
        self.changeDelta()
        self.changeHeight()
        
        self.overlayHeight = dimensions.height / 2
        self.y = self.dimensions.height + self.overlayHeight
        
        // The cover layer is the opaque rectangle that hides all characters
        let coverLayer = CALayer()
        coverLayer.backgroundColor = Preferences.shared.BACKGROUND_COLOR.cgColor
        coverLayer.bounds = CGRect(x: 0, y: 0, width: Preferences.shared.FONT_SIZE, height: self.dimensions.height)
        coverLayer.position = CGPoint(x: self.x + (Preferences.shared.FONT_SIZE / 2), y: self.overlayHeight)
        self.overlayView.layer?.addSublayer(coverLayer)
        
        // the mask layer acts as a window that reveals a portion of the text below the cover layer.
        maskLayer.backgroundColor = NSColor.white.cgColor
        let path = CGMutablePath()
        // this subpath is that of the entire rectange
        path.addRect(CGRect(x: 0, y: 0, width: Preferences.shared.FONT_SIZE, height: self.dimensions.height))
        // this subpath is that of the window that should reveal the text
        path.addRect(CGRect(origin: CGPoint(x: 0, y: self.y), size: CGSize(width: Preferences.shared.FONT_SIZE, height: self.overlayHeight)))
        path.closeSubpath()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        coverLayer.mask = maskLayer

        // the gradient layer is adds a gradient over the text revealed by the mask layer to give a fade-out effect
        // to the text. If custom paths could be defined for the gradient layer (a CAGradientLayer struct), then
        // the gradient layer and the mask layer could be the same object.
        self.gradientLayer.colors = [
                        Preferences.shared.BACKGROUND_COLOR.cgColor,
                        NSColor.clear.cgColor,
                        Preferences.shared.BACKGROUND_COLOR.cgColor,
                    ]
        self.gradientLayer.locations = [0.0, 0.1, 0.9]
        self.gradientLayer.frame = CGRect(x: self.x, y: self.y, width: Preferences.shared.FONT_SIZE * 2, height: self.overlayHeight)
        self.overlayView.layer?.addSublayer(self.gradientLayer)
    }
    
    func animateOneFrame() {
        y -= self.delta
        if (y <= -self.overlayHeight) {
            y = self.dimensions.height + self.overlayHeight
            self.changeDelta()
            self.changeHeight()
        }
    }
    
    func draw() {
        // update the position of the overlay without animating between positions.
        // this fixes the flickering that happens when we reset the overlay to the
        // top of the screen.
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: Preferences.shared.FONT_SIZE, height: self.dimensions.height))
        path.addRect(CGRect(origin: CGPoint(x: 0, y: self.y), size: CGSize(width: Preferences.shared.FONT_SIZE, height: self.overlayHeight)))
        path.closeSubpath()
        maskLayer.path = path
        self.gradientLayer.frame = CGRect(x: self.x, y: self.y, width: Preferences.shared.FONT_SIZE, height: self.overlayHeight)
        CATransaction.commit()
    }
    
    func changeDelta() {
        let extra = Double(Int.random(in: 0..<(2 * Int(Preferences.shared.BASE_RAIN_SPEED))))
        self.delta = Preferences.shared.BASE_RAIN_SPEED + extra
    }
    
    func changeHeight() {
        let numCharacters = Int.random(in: 2...6) * 4
        self.overlayHeight = Preferences.shared.FONT_SIZE * Double(numCharacters)
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        let path = CGMutablePath()
        // this subpath is that of the entire rectange
        path.addRect(CGRect(x: 0, y: 0, width: Preferences.shared.FONT_SIZE, height: self.dimensions.height))
        // this subpath is that of the window that should reveal the text
        path.addRect(CGRect(origin: CGPoint(x: 0, y: self.y), size: CGSize(width: Preferences.shared.FONT_SIZE, height: self.overlayHeight)))
        path.closeSubpath()
        maskLayer.path = path
        self.gradientLayer.frame = CGRect(x: self.x, y: self.y, width: Preferences.shared.FONT_SIZE, height: self.overlayHeight)
        CATransaction.commit()
    }
    
    var view: NSView {
        get {
            return self.overlayView
        }
    }
}
