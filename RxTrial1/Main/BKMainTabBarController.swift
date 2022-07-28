//
//  MainTabBarController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit

class BKMainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var viewControllers: [UIViewController] = []
        
        let viewModel = BKFactory.shared.newViewModel()
        let translatorVC = BKNewViewController(viewModel: viewModel)
        let translatorNaviVC = UINavigationController(rootViewController: translatorVC)
        translatorNaviVC.tabBarItem = UITabBarItem(title: "New", image: UIImage(systemName: "square.and.pencil"), tag: 0)
        
        let archiveVC = BKArchiveViewController(viewModel: BKFactory.shared.archiveViewModel())
        let archiveNaviVC = UINavigationController(rootViewController: archiveVC)
        archiveNaviVC.tabBarItem = UITabBarItem(title: "Archive", image: UIImage(systemName: "archivebox"), tag: 1)
        
        viewControllers.append(translatorNaviVC)
        viewControllers.append(archiveNaviVC)
        
        setViewControllers(viewControllers, animated: false)
        
                
        //        naviVC.navigationBar.prefersLargeTitles = true
    }

}
