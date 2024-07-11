//
//  DigitalRainScreenSaver.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import ScreenSaver

let PREVIEW_FONT_SIZE: Double = 15
let PREVIEW_DELTA: Double = 3

class DigitalRainScreenSaver : ScreenSaverView {
    private let screenWidth: Double
    private let screenHeight: Double
    private var columns: Array<RainColumn> = []
    
    private let preferencesController = DigitalRainPreferencesController()
    
    override init?(frame: NSRect, isPreview: Bool) {
        self.screenWidth = frame.size.width
        self.screenHeight = frame.size.height
        
        super.init(frame: frame, isPreview: isPreview)
        
        super.animationTimeInterval = 1 / 30
        
        // Need to subscribe to "willStop" notification to terminate ScreenSaverView instances that
        // have persisted between invocations of the screen saver. This is hack to get around a bug
        // with the "legacyScreenSaver (wallpaper)" process that does not terminate when the screen
        // saver terminates (it should though...). Hopefully this bug will be fixed and this
        // subscription can be removed with no other code changes.
        DistributedNotificationCenter.default.addObserver(
                   self,
                   selector: #selector(willStop(_:)),
                   name: Notification.Name("com.apple.screensaver.willstop"),
                   object: nil
               )
        
        // Subscribing to notification to update the background color whenever the UserDefaults object updates.
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: nil,
            using: { _ in  self.updateBackgroundColor() }
        )
        
        super.wantsLayer = true;
        super.layer = CALayer()
        self.updateBackgroundColor()
        
        let numColumns = Int(ceil(self.screenWidth / (isPreview ? PREVIEW_FONT_SIZE : Preferences.shared.FONT_SIZE)))
        let context = ScreenSaverContext(
            screenWidth: self.screenWidth,
            screenHeight: self.screenHeight,
            numColumns: numColumns,
            isPreview: isPreview
        )
        for i in 0..<numColumns {
            let column = RainColumn(columnIndex: i, context: context)
            self.columns.append(column)
        }
        
        for column in columns {
            super.addSubview(column.view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Notification (event) handler that fires when the "willStop" notification is sent to this ScreenSaverView instance.
     * This handler terminates the current instance, if the current instance is not the preview. Albeit a hack, this handler
     * stops a memory leak with a MacOS screen saver process. Hopefully this bug will be fixed and this handler can
     * be removed with no other code changes.
     */
    @objc func willStop(_ aNotification: Notification) {
        if (!isPreview) {
            NSApplication.shared.terminate(nil)
        }
    }
    
    override func animateOneFrame() {
        for column in columns {
            column.animateOneFrame()
            column.draw()
        }
    }
    
    private func updateBackgroundColor() {
        super.layer?.backgroundColor = Preferences.shared.BACKGROUND_COLOR.cgColor
    }
 
    override var hasConfigureSheet: Bool { return self.configureSheet != nil }
    override var configureSheet: NSWindow? {
        get {
            return preferencesController.window
        }
    }
}
