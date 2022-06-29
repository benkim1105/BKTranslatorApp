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
        let viewModel = BKFactory.shared.translatorViewModel()
        let translatorVC = TranslatorViewController(viewModel: viewModel)
        translatorVC.navigationItem.largeTitleDisplayMode = .always
        let naviVC = UINavigationController(rootViewController: translatorVC)
        naviVC.navigationBar.prefersLargeTitles = true
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }

}

