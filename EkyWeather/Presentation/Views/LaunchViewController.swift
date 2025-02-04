//
//  LaunchViewController.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    let lottieView: LottieAnimationView = {
        let view = LottieAnimationView(name: "clapperboard")
        view.loopMode = .loop
        view.frame = .init(x: 0, y: 0, width: 300, height: 300)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        setupLottieAnimation()
    }
    
    private func setupLottieAnimation() {
        lottieView.center = view.center
        lottieView.alpha = 0
        lottieView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    
        view.addSubview(lottieView)
        
        UIView.animate(
            withDuration: 1.0,
            delay: 1.0,
            usingSpringWithDamping: 0.5, // Bouncy effect (less damping = more bounce)
            initialSpringVelocity: 0.7, // Speed of bounce
            options: .curveEaseInOut, // Smooth ease-in-out curve
            animations: { [weak self] in
                self?.lottieView.alpha = 1.0
                self?.lottieView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
            completion: { [weak self] _ in
                self?.lottieView.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    let loginVC = LoginViewController()
                    
                    self?.navigationController?.setViewControllers([loginVC], animated: true)
                }
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lottieView.stop()
    }
}

@available(iOS 17, *)
#Preview {
    LaunchViewController()
 }
