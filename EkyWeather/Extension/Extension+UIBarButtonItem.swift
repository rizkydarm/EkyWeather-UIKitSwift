//
//  Extension+UIBarButtonItem.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(image: UIImage?, action: UIAction) {
        self.init()
        self.image = image
        self.primaryAction = action
    }
    
    convenience init(title: String?, style: UIBarButtonItem.Style, action: UIAction) {
        self.init()
        self.title = title
        self.style = style
        self.primaryAction = action
    }
}
