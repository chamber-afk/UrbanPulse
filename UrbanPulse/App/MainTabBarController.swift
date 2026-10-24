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
        setupTabBarAppearance()
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
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = .black

        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

}
