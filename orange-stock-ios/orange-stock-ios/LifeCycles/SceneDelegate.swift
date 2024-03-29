//
//  SceneDelegate.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowSecene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowSecene)
        // 유저디폴트에 저장된 화면 설정값으로 설정
        AppearanceManager().setUserInterfaceStyle(at: window)
        window?.rootViewController = UINavigationController(rootViewController: FavoriteStockListViewController())
        window?.makeKeyAndVisible()
    }
}
