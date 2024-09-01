//
//  TabBarController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit


final class TabBarController: UITabBarController {
    enum TabInActiveImage {
        static let feedInActive = UIImage(systemName: "number")
        static let profileInactive = UIImage(systemName: "person")
        static let searchInactive = UIImage(systemName: "magnifyingglass")
        static let bookStorageInactive = UIImage(systemName: "square.and.arrow.down")
    }
    
    enum TabActiveImage {
        static let feedActive = UIImage(systemName: "number")
        static let profileActive = UIImage(systemName: "person.fill")
        static let searchActive = UIImage(systemName: "magnifyingglass")
        static let bookStorageActive = UIImage(systemName: "square.and.arrow.down.fill")
    }
    
    override func viewDidLoad() {
        tabBar.tintColor = Resource.Colors.primaryColor
        tabBar.unselectedItemTintColor = Resource.Colors.lightGray
        tabBar.backgroundColor = Resource.Colors.white
        
        let feedView = UINavigationController(rootViewController: FeedTabManViewController())
        let searchView = UINavigationController(rootViewController: SearchViewController())
        let profileView = UINavigationController(rootViewController: ProfileViewController())

        setViewControllers([feedView, searchView, profileView], animated: true)
        
        if let items = tabBar.items {
            items[0].image = TabInActiveImage.feedInActive
            items[0].selectedImage = TabActiveImage.feedActive
            
            items[1].image = TabInActiveImage.searchInactive
            items[1].selectedImage = TabActiveImage.searchActive
            
            items[2].image = TabInActiveImage.profileInactive
            items[2].selectedImage = TabActiveImage.profileActive
        }
    }
}
