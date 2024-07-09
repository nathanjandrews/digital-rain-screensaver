//
//  DigitalRainScreenSaver.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import ScreenSaver

class DigitalRainScreenSaver : ScreenSaverView {
    private let dimensions: ScreenDimensions
    private var columns: Array<RainColumn> = []
    
    override init?(frame: NSRect, isPreview: Bool) {
        dimensions = ScreenDimensions(width: frame.size.width, height: frame.size.height)
        
        super.init(frame: frame, isPreview: isPreview)
        
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
        
        super.animationTimeInterval = 1 / 30
        
        columns.append(RainColumn(x: self.dimensions.width / 2, dimensions: self.dimensions))
        
        for column in columns {
            super.addSubview(column.subview)
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
    
    override func animateOneFrame() {}
 
    override var hasConfigureSheet: Bool { return false }
    override var configureSheet: NSWindow? { return nil }
}
