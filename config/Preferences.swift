//
//  Preferences.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation
import AppKit

let PREFERENCES_KEY_PREFIX = "digital-rain-screen-saver-"

class Preferences {
    @DefaultPreference<Double>(key: "font-size") var FONT_SIZE = 80
    @DefaultPreference<String>(key: "character-seed-string") var CHARACTER_SEED_STRING = "ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ012345789Z"
    @DefaultPreference<Double>(key: "base-rain-speed") var BASE_RAIN_SPEED = 10
    @DefaultPreferenceColor(key: "background-color") var BACKGROUND_COLOR = NSColor.black
    @DefaultPreferenceColor(key: "text-color") var TEXT_COLOR = NSColor(srgbRed: 3 / 256, green: 160 / 256, blue: 98 / 256, alpha: 1)
    
    static let shared = Preferences()
    
    private init() {}
    
    internal func reset() {
        self.FONT_SIZE = 40
        self.CHARACTER_SEED_STRING = "ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ012345789Z"
        self.BASE_RAIN_SPEED = 10
        self.BACKGROUND_COLOR = NSColor.black
        self.TEXT_COLOR = NSColor(srgbRed: 3 / 256, green: 160 / 256, blue: 98 / 256, alpha: 1)
    }
}

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
            guard let colorString = self.userDefaults.string(forKey: self.key) else { return self.defaultColor }
            return decodeColor(hexString: colorString)
        }
        set {
            let colorString = encodeColor(color: newValue)
            self.userDefaults.set(colorString, forKey: self.key)
        }
    }
    
    private func encodeColor(color: NSColor) -> String {
        guard let rgbColor = color.usingColorSpace(.sRGB) else { return "#FFFFFFFF" }
                
                let red = Int(rgbColor.redComponent * 255.0)
                let green = Int(rgbColor.greenComponent * 255.0)
                let blue = Int(rgbColor.blueComponent * 255.0)
                let alpha = Int(rgbColor.alphaComponent * 255.0)
                
                return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }
    
    private func decodeColor(hexString: String) -> NSColor {
        var hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
               if hex.count == 6 {
                   hex += "FF"
               }
               
        guard hex.count == 8 else { return NSColor.white }
               
               var rgb: UInt64 = 0
               Scanner(string: hex).scanHexInt64(&rgb)
               
               let red = CGFloat((rgb >> 24) & 0xFF) / 255.0
               let green = CGFloat((rgb >> 16) & 0xFF) / 255.0
               let blue = CGFloat((rgb >> 8) & 0xFF) / 255.0
               let alpha = CGFloat(rgb & 0xFF) / 255.0
               
               return NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
}

/**
 * Property wrapper class that handles setting and getting a value from the UserDefaults database,
 * or the default value if there is no value in the database.
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
            let retreivedValue = self.userDefaults.object(forKey: self.key)
            if (retreivedValue == nil) {
                return defaultValue
            }
            
            return retreivedValue as! T
        }
        set {
            self.userDefaults.setValue(newValue, forKey: self.key)
        }
    }
}
