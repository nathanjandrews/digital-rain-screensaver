//
//  Preferences.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import AppKit

private let PREFERENCES_KEY_PREFIX = "digital-rain-screen-saver-"

/**
 * Class for managing user preferences. The singleton instance of this class, `shared`, can be used anywhere in the application.
 * Setting the fields of this class will update the stored value in the `UserDefaults` database. Getting values from this class
 */
class Preferences {
    @DefaultPreference<Double>(key: "font-size") var FONT_SIZE = 40
    @DefaultPreference<String>(key: "character-seed-string") var CHARACTER_SEED_STRING = "ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ012345789Z"
    @DefaultPreference<Double>(key: "base-rain-speed") var BASE_RAIN_SPEED = 10
    @DefaultPreferenceColor(key: "background-color") var BACKGROUND_COLOR = NSColor.black
    @DefaultPreferenceColor(key: "text-color") var TEXT_COLOR = NSColor(srgbRed: 3 / 256, green: 160 / 256, blue: 98 / 256, alpha: 1)
    @DefaultPreferenceColor(key: "text-highlight-color") var TEXT_HIGHLIGHT_COLOR = NSColor(srgbRed: 73 / 256, green: 252 / 256, blue: 181 / 256, alpha: 1)
    
    static let shared = Preferences()
    
    private init() {}
    
    internal func reset() {
        self.FONT_SIZE = 40
        self.CHARACTER_SEED_STRING = "ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ012345789Z"
        self.BASE_RAIN_SPEED = 10
        self.BACKGROUND_COLOR = NSColor.black
        self.TEXT_COLOR = NSColor(srgbRed: 3 / 256, green: 160 / 256, blue: 98 / 256, alpha: 1)
        self.TEXT_HIGHLIGHT_COLOR = NSColor(srgbRed: 4 / 256, green: 224 / 256, blue: 135 / 256, alpha: 1)
    }
}

/**
 * Property wrapper class specifically for `NSColor` objects. Colors require special care since they are
 * not a [supported default object](https://developer.apple.com/documentation/foundation/userdefaults/#2926904).
 * To store a color, we encode the color as an `NSData` instance so that it can be stored. When retrieving the
 * color, we decode the stored `NSData` to an `NSColor` before returning
 */
@propertyWrapper
private class DefaultPreferenceColor {
    private let userDefaults = UserDefaults.standard
    private let defaultColor: NSColor
    private let key: String
    
    init(wrappedValue: NSColor, key: String) {
        self.key = PREFERENCES_KEY_PREFIX + key
        self.defaultColor = wrappedValue
    }
    
    var wrappedValue: NSColor {
        get {
            guard let colorData = self.userDefaults.data(forKey: self.key) else { return self.defaultColor }
            guard let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData) else { return self.defaultColor }
            return color
        }
        set {
            guard let colorData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) else {
                self.userDefaults.set(self.defaultColor, forKey: self.key)
                return
            }
            self.userDefaults.set(colorData, forKey: self.key)
        }
    }
}

/**
 * Property wrapper class that handles setting and getting a value from the UserDefaults database,
 * or the default value if there is no value in the database.
 *
 * > :warning: **Warning:** The type parameter `T` must be one of the [supported default types](https://developer.apple.com/documentation/foundation/userdefaults/#2926904).
 */
@propertyWrapper
private class DefaultPreference<T> {
    private let userDefaults = UserDefaults.standard
    private let defaultValue: T
    private let key: String
    
    init(wrappedValue: T, key: String) {
        self.key = PREFERENCES_KEY_PREFIX + key
        self.defaultValue = wrappedValue
    }
    
    var wrappedValue: T {
        get {
            let retrievedValue = self.userDefaults.object(forKey: self.key)
            if (retrievedValue == nil) {
                return defaultValue
            }
            
            return retrievedValue as! T
        }
        set {
            self.userDefaults.setValue(newValue, forKey: self.key)
        }
    }
}
