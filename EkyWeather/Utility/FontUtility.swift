//
//  FontUtility.swift
//  EkyWeather
//
//  Created by Eky on 20/01/25.
//

import UIKit

struct FontUtility {
    static let screenSize = UIScreen.main.bounds.size
    static let baseScreenWidth: CGFloat = 390 // Reference screen width (e.g., iPhone 14 Pro)

    /// Get a dynamically scaled font size based on the device's screen size
    /// - Parameters:
    ///   - baseFontSize: The font size used in the design (reference size).
    ///   - minimumFontSize: The minimum font size to ensure readability on smaller devices.
    /// - Returns: The adjusted font size for the current screen.
    static func scaledFontSize(baseFontSize: CGFloat, minimumFontSize: CGFloat = 12) -> CGFloat {
        let scale = screenSize.width / baseScreenWidth
        let scaledSize = baseFontSize * scale
        return max(scaledSize, minimumFontSize) // Ensure it doesn't go below the minimum size
    }

    /// Create a dynamically scaled font
    /// - Parameters:
    ///   - baseFontSize: The font size used in the design (reference size).
    ///   - fontWeight: The desired font weight.
    ///   - minimumFontSize: The minimum font size.
    /// - Returns: A UIFont with a dynamically adjusted size.
    static func scaledFont(baseFontSize: CGFloat, fontWeight: UIFont.Weight = .regular, minimumFontSize: CGFloat = 12) -> UIFont {
        let fontSize = scaledFontSize(baseFontSize: baseFontSize, minimumFontSize: minimumFontSize)
        return UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
}
