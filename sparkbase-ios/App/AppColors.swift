import SwiftUI
import UIKit

extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
    }

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, alpha: Double(a) / 255)
    }
}

extension Color {
    static let appPrimary = Color(uiColor: .dynamicColor(light: UIColor(hex: "#2563EB"), dark: UIColor(hex: "#6C9BFF")))
    static let appOnPrimary = Color(uiColor: .dynamicColor(light: UIColor(hex: "#FFFFFF"), dark: UIColor(hex: "#001A6E")))
    static let appPrimaryContainer = Color(uiColor: .dynamicColor(light: UIColor(hex: "#DBEAFE"), dark: UIColor(hex: "#1E3A7A")))
    static let appSecondary = Color(uiColor: .dynamicColor(light: UIColor(hex: "#F43F5E"), dark: UIColor(hex: "#FB7185")))
    static let appBackground = Color(uiColor: .dynamicColor(light: UIColor(hex: "#F8FAFC"), dark: UIColor(hex: "#0F172A")))
    static let appSurface = Color(uiColor: .dynamicColor(light: UIColor(hex: "#FFFFFF"), dark: UIColor(hex: "#1E293B")))
    static let appSurfaceVariant = Color(uiColor: .dynamicColor(light: UIColor(hex: "#F1F5F9"), dark: UIColor(hex: "#334155")))
    static let appTextPrimary = Color(uiColor: .dynamicColor(light: UIColor(hex: "#0F172A"), dark: UIColor(hex: "#F8FAFC")))
    static let appTextSecondary = Color(uiColor: .dynamicColor(light: UIColor(hex: "#64748B"), dark: UIColor(hex: "#94A3B8")))
    static let appPrice = Color(uiColor: .dynamicColor(light: UIColor(hex: "#1D4ED8"), dark: UIColor(hex: "#93C5FD")))
    static let appDiscount = Color(uiColor: .dynamicColor(light: UIColor(hex: "#DC2626"), dark: UIColor(hex: "#F87171")))
    static let appSuccess = Color(uiColor: .dynamicColor(light: UIColor(hex: "#16A34A"), dark: UIColor(hex: "#4ADE80")))
    static let appWarning = Color(uiColor: .dynamicColor(light: UIColor(hex: "#D97706"), dark: UIColor(hex: "#FCD34D")))
    static let appError = Color(uiColor: .dynamicColor(light: UIColor(hex: "#DC2626"), dark: UIColor(hex: "#F87171")))
    static let appDivider = Color(uiColor: .dynamicColor(light: UIColor(hex: "#E2E8F0"), dark: UIColor(hex: "#334155")))
}

struct AppFont {
    static func largeTitle()  -> Font { .system(size: 34, weight: .bold,     design: .rounded) }
    static func title1()      -> Font { .system(size: 28, weight: .bold,     design: .rounded) }
    static func title2()      -> Font { .system(size: 22, weight: .semibold, design: .rounded) }
    static func title3()      -> Font { .system(size: 20, weight: .semibold, design: .default) }
    static func headline()    -> Font { .system(size: 17, weight: .semibold) }
    static func body()        -> Font { .system(size: 17, weight: .regular)  }
    static func callout()     -> Font { .system(size: 16, weight: .regular)  }
    static func subheadline() -> Font { .system(size: 15, weight: .regular)  }
    static func footnote()    -> Font { .system(size: 13, weight: .regular)  }
    static func caption1()    -> Font { .system(size: 12, weight: .regular)  }
    static func caption2()    -> Font { .system(size: 11, weight: .regular)  }
    static func price()       -> Font { .system(size: 20, weight: .bold,     design: .rounded) }
    static func badge()       -> Font { .system(size: 11, weight: .semibold, design: .rounded) }
}
