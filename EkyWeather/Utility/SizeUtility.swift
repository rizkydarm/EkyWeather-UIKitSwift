//
//  SizeUtility.swift
//  EkyWeather
//
//  Created by Eky on 20/01/25.
//

import UIKit

struct SizeUtility {
    static let screenSize = UIScreen.main.bounds.size

    /// Resize a dimension (width or height) based on the reference screen size
    /// - Parameters:
    ///   - value: The original value based on the design reference.
    ///   - referenceSize: The reference screen size (default is iPhone 14 Pro).
    /// - Returns: The resized dimension.
    static func resizeDimension(_ value: CGFloat, basedOn referenceSize: CGSize = CGSize(width: 390, height: 844)) -> CGFloat {
        let scale = screenSize.width / referenceSize.width
        return value * scale
    }

    /// Resize a view's frame based on the reference screen size
    /// - Parameters:
    ///   - view: The view to resize.
    ///   - referenceFrame: The frame used in the reference design.
    static func resizeView(_ view: UIView, basedOn referenceFrame: CGRect) {
        let width = resizeDimension(referenceFrame.width)
        let height = resizeDimension(referenceFrame.height)
        let x = resizeDimension(referenceFrame.origin.x)
        let y = resizeDimension(referenceFrame.origin.y)
        view.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
