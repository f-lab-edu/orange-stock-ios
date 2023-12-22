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
        
        makeKeyAndVisible()
    }
}

extension SceneDelegate {
    /// 로그인 필요 여부에 따라 rootViewController 변경
    private func makeKeyAndVisible() {
        let loginViewModel = LoginViewModel()
        loginViewModel.isNeedAppleLogin { needLogin in
            DispatchQueue.main.async {
                let rootViewController = needLogin
                 ? LoginViewController()
                 : FavoriteStockListViewController()
                self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
                self.window?.makeKeyAndVisible()
            }
        }
    }
}

