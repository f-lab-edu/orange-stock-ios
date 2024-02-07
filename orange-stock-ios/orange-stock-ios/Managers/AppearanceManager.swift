//
//  AppearanceManager.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/10.
//
//
import UIKit

// MARK: Enum

enum AppearanceType: Int, CaseIterable {
    case system
    case light
    case dark
    
    var appearanceSetting: AppearanceSetting {
        switch self {
        case .system:
            return SystemAppearanceSetting()
        case .light:
            return LightAppearanceSetting()
        case .dark:
            return DarkAppearanceSetting()
        }
    }
}

// MARK: Protocol

protocol AppearanceSetting {
    var appearanceType: AppearanceType { get }
    var title: String { get }
    var userInterfaceStyle: UIUserInterfaceStyle { get }
}

// MARK: Structs - Appearance Setting Attributes

struct SystemAppearanceSetting: AppearanceSetting {
    var appearanceType = AppearanceType.system
    var title = "시스템 설정과 같이"
    var userInterfaceStyle = UIWindow().traitCollection.userInterfaceStyle
}

struct LightAppearanceSetting: AppearanceSetting {
    var appearanceType = AppearanceType.light
    var title = "밝은 모드"
    var userInterfaceStyle = UIUserInterfaceStyle.light
}

struct DarkAppearanceSetting: AppearanceSetting {
    var appearanceType = AppearanceType.dark
    var title = "어두운 모드"
    var userInterfaceStyle = UIUserInterfaceStyle.dark
}

// MARK: AppearaceManager

struct AppearanceManager {

    func setUserInterfaceStyle(at window: UIWindow?) {
        setUserInterfaceStyle(userInterfaceStyle(), window: window)
    }
    
    func setAppearanceSetting(_ appearanceSetting: AppearanceSetting) {
        // 유저디폴트에 변경된 세팅 값 저장
        saveAppearanceSetting(appearanceSetting)
        setUserInterfaceStyle(appearanceSetting.userInterfaceStyle, window: currentWindow())
    }
    
    func appearanceType() -> AppearanceType {
        return currentAppearanceSetting().appearanceType
    }
    
    func userInterfaceStyle() -> UIUserInterfaceStyle {
        return currentAppearanceSetting().userInterfaceStyle
    }
    
    private func currentAppearanceSetting() -> AppearanceSetting {
        return UserDefaultsManager.shared.getAppearanceSetting()
    }
    
    private func saveAppearanceSetting(_ appearanceSetting: AppearanceSetting) {
        UserDefaultsManager.shared.setAppearanceSetting(appearanceSetting)
    }
    
    private func currentWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    
    private func setUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle, window: UIWindow?) {
        window?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}
