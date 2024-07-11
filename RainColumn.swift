//
//  RainColumn2.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/10/24.
//

import Foundation
import AppKit

private func highlightOdds() -> Bool {
    return Int.random(in: 1...5) == 1
}

class RainColumn {
    private let FONT_SIZE: Double
    private let BASE_DELTA: Double
    
    private let columnIndex: Int
    private let x: Double
    private let context: ScreenSaverContext
    private let _view = NSView()
    
    private let textLayer = CATextLayer()
    private let gradientLayer = CAGradientLayer()
    
    private var y: Double = 0
    private var overlayHeight: Double = 0
    private var delta: Double = 0;
    private var doHighlight = highlightOdds()
    
    private let FRAMES_BETWEEN_SWAPS = 5
    private var framesWaited = 0
    
    init(columnIndex: Int, context: ScreenSaverContext) {
        self.FONT_SIZE = context.isPreview ? PREVIEW_FONT_SIZE : Preferences.shared.FONT_SIZE
        self.BASE_DELTA = context.isPreview ? PREVIEW_DELTA : Preferences.shared.BASE_RAIN_SPEED
        
        self.columnIndex = columnIndex
        self.x = Double(columnIndex) * self.FONT_SIZE
        self.context = context
        
        self.changeHeight()
        self.changeDelta()
        
        // restrict the first drop so the middle column always drops first before the rest
        if (!context.isPreview) {
            let isMiddleColumn = context.numColumns / 2 == self.columnIndex
            if (isMiddleColumn) {
                self.changeHeight(percentage: 1)
                self.changeDelta(percentage: 1.5)
                self.y = self.context.screenHeight + self.overlayHeight
            } else {
                self.y = self.context.screenHeight + self.overlayHeight + self.randomHeightOffset() + 800
            }
        } else {
            // need to set the y value to hide the overlay above the screen if we are in preview mode
            self.y = self.context.screenHeight + self.overlayHeight + self.randomHeightOffset()
        }
        
 
        self._view.wantsLayer = true
        self._view.layer = CALayer()
        
        //----------------------------//
        // Initializing the textLayer //
        //----------------------------//
        self.textLayer.string = self.generateTextColumn()
        // 'ofSize' argument has no effect when using NSFont in this context
        self.textLayer.font = NSFont.monospacedSystemFont(ofSize: 0, weight: .regular)
        self.textLayer.fontSize = self.FONT_SIZE
        self.textLayer.alignmentMode = .center
        self.textLayer.foregroundColor = self.doHighlight ? Preferences.shared.TEXT_HIGHLIGHT_COLOR.cgColor : Preferences.shared.TEXT_COLOR.cgColor
        self.textLayer.bounds = CGRect(x: 0, y: 0, width: self.FONT_SIZE, height: self.context.screenHeight)
        self.textLayer.position = CGPoint(x: self.x + (self.FONT_SIZE / 2), y: self.context.screenHeight / 2)
        
        //--------------------------------//
        // Initializing the gradientLayer //
        //--------------------------------//
        self.gradientLayer.colors = [
            NSColor.clear.cgColor,
            NSColor.white.cgColor,
            NSColor.clear.cgColor,
        ]
        self.gradientLayer.locations = [0.0, 0.1, 0.9]
        self.updateGradientLayerFrame()

        //-------------------------------------//
        // Setting relationship between layers //
        //-------------------------------------//
        self.textLayer.mask = gradientLayer
        self._view.layer?.addSublayer(self.textLayer)
    }
    
    func animateOneFrame() {
        self.y -= self.delta
        if (self.y <= -self.overlayHeight) {
            self.y = self.context.screenHeight + self.overlayHeight + randomHeightOffset()
            self.changeDelta()
            self.textLayer.string = self.generateTextColumn()
            
            self.doHighlight = highlightOdds()
            self.updateHighlight()
        }
        
        self.framesWaited += 1
        if (self.framesWaited == self.FRAMES_BETWEEN_SWAPS) {
            self.swapCharacter()
            self.framesWaited = 0
        }
    }
    
    func draw() {
        // update the position of the overlay without animating between positions.
        // this fixes the flickering that happens when we reset the overlay to the
        // top of the screen.
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.updateGradientLayerFrame()
        CATransaction.commit()
    }
    
    //-----------------------------------------------------------//
    // Methods for interacting with the gradient over the column //
    //-----------------------------------------------------------//
    
    private func changeDelta() {
        self.changeDelta(percentage: Double.random(in: 0...1.5))
    }
    
    private func changeDelta(percentage: Double) {
        self.delta = self.BASE_DELTA * (1 + percentage)
    }
    
    private func randomHeightOffset() -> Double {
        return Double(Int.random(in: 5...12) * Int(self.FONT_SIZE))
    }
    
    private func changeHeight() {
        let randomPercentage = Double(Int.random(in: 6...16)) / 20
        self.changeHeight(percentage: randomPercentage)
    }
    
    private func changeHeight(percentage: Double) {
        self.overlayHeight = self.context.screenHeight * percentage
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.updateGradientLayerFrame()
        CATransaction.commit()
    }
    
    private func updateGradientLayerFrame() {
        self.gradientLayer.frame = CGRect(x: 0, y: self.y, width: self.FONT_SIZE, height: self.overlayHeight)
    }
    
    //-----------------------------------------------------//
    // Methods for interacting with the text in the column //
    //-----------------------------------------------------//
    
    private func swapCharacter() {
        var string = (self.textLayer.string as! String).replacingOccurrences(of: "\n", with: "")
        let randomIndex = string.index(string.startIndex, offsetBy: Int.random(in: 0..<string.count))
        string.replaceSubrange(randomIndex...randomIndex, with: self.generateRandomCharacter())
        self.textLayer.string = string.map { String($0) }.joined(separator: "\n")
    }
    
    private func generateTextColumn() -> String {
        return String((0..<self.numCharactersInColumn).map {_ in
            Preferences.shared.CHARACTER_SEED_STRING.randomElement()!
        }).map { String($0) }.joined(separator: "\n")
    }
    
    private func generateRandomCharacter() -> String {
        return String(Preferences.shared.CHARACTER_SEED_STRING.randomElement()!)
    }
    
    var numCharactersInColumn: Int {
        get {
            return Int(self.context.screenHeight / self.FONT_SIZE)
        }
    }
    
    //------//
    // Misc //
    //------//
    
    private func updateHighlight() {
        if (self.doHighlight) {
            self.textLayer.foregroundColor = Preferences.shared.TEXT_HIGHLIGHT_COLOR.cgColor
            self.textLayer.font = NSFont.monospacedSystemFont(ofSize: 0, weight: .bold)
        } else {
            self.textLayer.foregroundColor = Preferences.shared.TEXT_COLOR.cgColor
            self.textLayer.font = NSFont.monospacedSystemFont(ofSize: 0, weight: .regular)
        }
    }
    
    var view: NSView {
        get {
            return self._view
        }
    }
}
