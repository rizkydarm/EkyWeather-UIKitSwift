//
//  Extension+UIImage.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import Foundation
import UIKit

extension UIImage {
    func resize(_ newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / self.size.width
        let verticalRatio = newSize.height / self.size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            let newImage = renderer.image { context in
                self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
            return newImage
        } else {
            return self
        }
    }
    
    func reColor(_ color: UIColor) -> UIImage? {
        let tintedImage = self.withRenderingMode(.alwaysTemplate)
        let coloredImage = tintedImage.withTintColor(color)
        return coloredImage
    }
}
