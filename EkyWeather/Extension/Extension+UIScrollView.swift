//
//  Extension+ UIScrollView.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool, additionalBottomPadding: CGFloat = 0) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom + additionalBottomPadding)
        setContentOffset(bottomOffset, animated: animated)
    }
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
