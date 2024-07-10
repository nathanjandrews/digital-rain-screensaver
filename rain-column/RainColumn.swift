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
    private let view = NSView()
    private let text: Text;
    private let overlay: Overlay
    
    init(x: Double, dimensions: ScreenDimensions) {
        self.x = x;
        self.dimensions = dimensions
        
        self.text = Text(x: x, dimensions: dimensions)
        self.overlay = Overlay(x: x, dimensions: dimensions)
        
        self.view.addSubview(text.view)
        self.view.addSubview(overlay.view)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    func animateOneFrame() {
        self.text.animateOneFrame()
        self.overlay.animateOneFrame(textColumn: text)
    }
    
    func draw() {
        self.text.draw()
        self.overlay.draw()
    }
        
    var subview: NSView {
        get {
            return self.view
        }
    }
}
