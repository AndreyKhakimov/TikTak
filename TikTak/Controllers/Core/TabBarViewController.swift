//
//  TabBarViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    private func setUpControllers() {
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        let profile = ProfileViewController(user: User(username: "self", profilePictureURL: nil, identifier: "abc123"))
        
        notifications.title = "Notifications"
        profile.title = "Profile"
        
        let navVC1 = UINavigationController(rootViewController: home)
        let navVC2 = UINavigationController(rootViewController: explore)
        let navVC3 = UINavigationController(rootViewController: notifications)
        let navVC4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)
                
        navVC1.navigationBar.backgroundColor = .clear
        navVC1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC1.navigationBar.shadowImage = UIImage()
        
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        
        navVC1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        navVC2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        navVC3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        navVC4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)

        
        setViewControllers([navVC1, navVC2, cameraNav, navVC3, navVC4], animated: false)

        
    }

}
