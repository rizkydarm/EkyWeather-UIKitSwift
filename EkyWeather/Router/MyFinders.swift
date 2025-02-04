//
//  MyFinders.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import RouteComposer
import UIKit

class HomeVCFinder: StackIteratingFinder {
    
    typealias ViewController = HomeViewController
    typealias Context = Void

    let iterator: StackIterator = DefaultStackIterator()
    
    func isTarget(_ viewController: HomeViewController, with context: Void) -> Bool {
        return viewController is HomeViewController
    }
}
