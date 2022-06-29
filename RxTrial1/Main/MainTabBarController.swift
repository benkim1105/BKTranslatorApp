//
//  MainTabBarController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var viewControllers: [UIViewController] = []
        
        let viewModel = BKFactory.shared.translatorViewModel()
        let translatorVC = BKNewViewController(viewModel: viewModel)
        let translatorNaviVC = UINavigationController(rootViewController: translatorVC)
        translatorNaviVC.tabBarItem = UITabBarItem(title: "new", image: UIImage(systemName: "square.and.pencil"), tag: 0)
        
        
        
        viewControllers.append(translatorNaviVC)
        
        setViewControllers(viewControllers, animated: false)
        
                
        //        naviVC.navigationBar.prefersLargeTitles = true
    }

}
