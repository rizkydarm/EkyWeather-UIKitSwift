//
//  Extension+UIView.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import UIKit

enum GradientDirection {
    case vertical
    case horizontal
    case diagonal
}

extension UIView {
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        backgroundColor = color
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { subView in
            self.addSubview(subView)
        }
    }
    
    func setCornerRadius(_ radius: CGFloat, maskedCorner: CACornerMask? = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorner ?? [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        clipsToBounds = true
    }
    
    func setCornerRadiusRounded() {
        let heigth = self.frame.height
        layer.cornerRadius = heigth/2
        clipsToBounds = true
    }
    
    func setGradientBackground(_ colors: [UIColor], direction: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        switch direction {
            case .vertical:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            case .horizontal:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            case .diagonal:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }

        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
