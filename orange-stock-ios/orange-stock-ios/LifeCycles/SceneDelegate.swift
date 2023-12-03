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
        // 앱이 foreground에 올라오면 accessToken 발행
        OAuthAPIService().accessToken { result in
            switch result {
            case .success(let token):
                UserDefaultsManager.shared.setAccessToken(token)
            case .failure(let error):
                // TODO: Error 처리 어떻게 할지
                print(error.localizedDescription)
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 백그라운드 진입 시 accessToken 폐기
        let accessToken = UserDefaultsManager.shared.getAccessToken()
        OAuthAPIService().revokeToken(accessToken) { result in
            switch result {
            case .success(let response):
                if response.code == 200 {
                    UserDefaultsManager.shared.clear(.accessToken)
                }
            case .failure(let error):
                // TODO: Error 처리 어떻게 할지
                print(error.localizedDescription)
            }
        }
    }
}

