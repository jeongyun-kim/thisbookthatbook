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
    }
    
    enum TabActiveImage {
        static let feedActive = UIImage(systemName: "number")
        static let profileActive = UIImage(systemName: "person.fill")
    }
    
    override func viewDidLoad() {
        tabBar.tintColor = Resource.Colors.primaryColor
        tabBar.unselectedItemTintColor = Resource.Colors.lightGray
        tabBar.backgroundColor = Resource.Colors.white
        
        let feedView = UINavigationController(rootViewController: FeedViewController())
        let profileView = UINavigationController(rootViewController: ProfileViewController())

        setViewControllers([feedView, profileView], animated: true)
        
        if let items = tabBar.items {
            items[0].image = TabInActiveImage.feedInActive
            items[0].selectedImage = TabActiveImage.feedActive
            
            items[1].image = TabInActiveImage.profileInactive
            items[1].selectedImage = TabActiveImage.profileActive
        }
    }
}
