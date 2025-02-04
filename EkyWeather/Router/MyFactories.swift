//
//  MyFactories.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import RouteComposer
import UIKit

struct HomeVCFactory: Factory {
    func build(with context: Void) throws -> HomeViewController {
        return HomeViewController()
    }
}

struct LoginVCFactory: Factory {
    func build(with context: Void) throws -> LoginViewController {
        return LoginViewController()
    }
}
