//
//  MainTabBarController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 17/09/26.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let homeNav = makeTab(rootVC: HomeViewController(), title: "Home", imageName: "house")
        let searchNav = makeTab(rootVC: SearchViewController(), title: "Search", imageName: "magnifyingglass")
        let favoritesNav = makeTab(rootVC: FavoritesViewController(), title: "Favorites", imageName: "heart")
        let walletNav = makeTab(rootVC: TicketWalletViewController(), title: "Wallet", imageName: "ticket")
        

        viewControllers = [homeNav, searchNav, favoritesNav, walletNav]
    }
    
    private func makeTab(rootVC: UIViewController, title: String, imageName: String) -> UINavigationController {
        rootVC.title = title
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: nil
        )
        return nav
    }

}
