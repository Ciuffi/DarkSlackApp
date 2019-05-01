//
//  Preferences.swift
//  DarkSlack
//
//  Created by Giulio Rossi on 2019-04-30.
//  Copyright © 2019 Giulio Rossi. All rights reserved.
//

import Cocoa

struct Preferences {
    var url: String {
        get {
            // 2
            return UserDefaults.standard.string(forKey: "url") ?? "https://github.com/widget-/slack-black-theme"
        }
        set {
            // 4
            UserDefaults.standard.set(newValue, forKey: "url")
        }
    }
    var customURL: String {
        get {
            return UserDefaults.standard.string(forKey: "customURL") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "customURL")
        }
    }
}

