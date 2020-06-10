//
//  GHFTabBarController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/4/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavController(), createFavoritesNavController()]
    }
    
    func createSearchNavController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func createFavoritesNavController() -> UINavigationController {
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesViewController)
    }

}
