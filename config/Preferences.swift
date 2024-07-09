//
//  Preferences.swift
//  digital-rain-screensaver
//
//  Created by Nathan Andrews on 7/8/24.
//

import Foundation

let PREFERENCES_KEY_PREFIX = "digital-rain-screen-saver-"

class Preferences {
    @DefaultPreference<Double>(key: "font-size") var FONT_SIZE = 40
    @DefaultPreference<String>(key: "character-seed-string") var CHARACTER_SEED_STRING = "ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ012345789Z"
    
    static let shared = Preferences()
    
    private init() {}
    
    internal func reset() {
        self.FONT_SIZE = 40
        self.CHARACTER_SEED_STRING = "ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ012345789Z"
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
