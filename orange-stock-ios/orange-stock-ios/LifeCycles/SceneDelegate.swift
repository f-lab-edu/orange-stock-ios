//
//  SceneDelegate.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowSecene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowSecene)
        // 유저디폴트에 저장된 화면 설정값으로 설정
        self.window?.overrideUserInterfaceStyle = AppearanceManager.shared.appearanceSetting.userInterfaceStyle
        
        self.window?.rootViewController = UINavigationController(rootViewController: FavoriteStockListViewController())
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

