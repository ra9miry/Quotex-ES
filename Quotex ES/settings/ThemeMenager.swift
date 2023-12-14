//
//  ThemeMenager.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 14.12.2023.
//

import Foundation

struct ThemeManager {
    static let themePreferenceKey = "themePreference"

    static var isDarkTheme: Bool {
        get {
            return UserDefaults.standard.bool(forKey: themePreferenceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: themePreferenceKey)
            NotificationCenter.default.post(name: .didChangeTheme, object: nil)
        }
    }
}

extension Notification.Name {
    static let didChangeTheme = Notification.Name("didChangeTheme")
}
