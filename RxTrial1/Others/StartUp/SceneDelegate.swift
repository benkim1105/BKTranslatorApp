//
//  SceneDelegate.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        
        let devVC = DevViewController()
        let mainVC = UINavigationController(rootViewController: devVC)
        
//        let mainVC = BKMainTabBarController()
        
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

