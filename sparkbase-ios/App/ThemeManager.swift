import SwiftUI

enum ColorSchemePreference: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light:  return "sun.max.fill"
        case .dark:   return "moon.fill"
        }
    }
}

@Observable final class ThemeManager {
    var preference: ColorSchemePreference {
        didSet { UserDefaults.standard.set(preference.rawValue, forKey: "colorSchemePreference") }
    }

    init() {
        let stored = UserDefaults.standard.string(forKey: "colorSchemePreference") ?? ""
        preference = ColorSchemePreference(rawValue: stored) ?? .system
    }
}
