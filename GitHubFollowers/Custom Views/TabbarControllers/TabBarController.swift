//
//  TabBarController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 10.03.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        //put searchNavController and favoritesNavController to the tabbar view controller
        viewControllers = [createSearchNavController(), createFavoritesNavController()]
    }

    func createSearchNavController() -> UINavigationController {
        let searchNavController = SearchViewController()
        searchNavController.title = "Search"
        searchNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchNavController)
    }

    func createFavoritesNavController() -> UINavigationController {
        let favoritesNavController = FavoritesListViewController()
        favoritesNavController.title = "Favorites"
        favoritesNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return UINavigationController(rootViewController: favoritesNavController)
    }
}
