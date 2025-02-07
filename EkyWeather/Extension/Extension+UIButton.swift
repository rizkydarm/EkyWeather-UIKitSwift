import UIKit

extension UIButton {
    func addBounceAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.7
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        if let indicator = self.subviews.compactMap({ $0 as? UIActivityIndicatorView }).first {
            return indicator
        } else {
            let newActivityIndicator = UIActivityIndicatorView(style: .medium)
            newActivityIndicator.hidesWhenStopped = true
            newActivityIndicator.color = self.titleColor(for: .normal) ?? .white
            newActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(newActivityIndicator)
            
            NSLayoutConstraint.activate([
                newActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                newActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            
            return newActivityIndicator
        }
    }
    
    private var isShowActivityIndicator: Bool {
        return self.activityIndicator.isAnimating
    }
    
    func showActivityIndicator() {
        if !isShowActivityIndicator {
            self.setTitle("", for: .disabled)
            self.isEnabled = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        if isShowActivityIndicator {
            self.isEnabled = true
            self.setTitle(self.titleLabel?.text, for: .normal)
            self.activityIndicator.stopAnimating()
        }
    }
}
