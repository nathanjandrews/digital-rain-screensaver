//
//  ScreenDimensions.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation

class ScreenSaverContext {
    let screenWidth: Double
    let screenHeight: Double
    let numColumns: Int
    
    init(screenWidth: Double, screenHeight: Double, numColumns: Int) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.numColumns = numColumns
    }
}
