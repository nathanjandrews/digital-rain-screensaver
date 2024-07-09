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
        
        self.textView.string = "Hello from RainColumn!"
    }
    
    var subview: NSView {
        get {
            return self.textView
        }
    }
}
