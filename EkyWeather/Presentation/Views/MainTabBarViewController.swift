//
//  MainTabBarViewController.swift
//  EkyWeather
//
//  Created by Eky on 21/01/25.
//


import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.delegate = self
        
        let home = UINavigationController(rootViewController: HomeViewController())
        home.setToolbarHidden(true, animated: false)
        home.setNavigationBarHidden(true, animated: false)
        let profile = UINavigationController(rootViewController: ProfileViewController())
        
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        home.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.resize(CGSize(width: 20, height: 20))
        
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        profile.tabBarItem.selectedImage = UIImage(systemName: "person")?.resize(CGSize(width: 20, height: 20))
        
        tabBar.isTranslucent = true
        tabBar.barTintColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor.accent
        
        setViewControllers([home, profile], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
