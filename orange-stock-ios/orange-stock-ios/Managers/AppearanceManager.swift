//
//  AppearanceManager.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/10.
//

import UIKit

// MARK: Enum: AppearanceSetting
/// 화면 설정 값
enum AppearanceSetting: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
    
    var title: String {
        switch self {
        case .system:
            return "시스템 설정과 같이"
        case .light:
            return "밝은 모드"
        case .dark:
            return "어두운 모드"
        }
    }
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
           return UIWindow().traitCollection.userInterfaceStyle
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// MARK: - AppearanceManager
/// 화면 설정 값에 따라 UI 색상 요소  관리 Singleton Class
final class AppearanceManager {
    
    static let shared = AppearanceManager()
    
    private init() {
        appearanceSetting = UserDefaultsManager.shared.getAppearanceSetting()
    }
    
    /// 화면 설정 값
    var appearanceSetting: AppearanceSetting {
        didSet {
            // App의 Appearance 변경
            setUserInterfaceStyle()
            // 유저디폴트에 설정값 저장
            UserDefaultsManager.shared.setAppearanceSetting(appearanceSetting)
        }
    }
    
    /// 윈도우의 화면 설정값을 사용자가 선택한 값으로 변경
    private func setUserInterfaceStyle() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        window?.overrideUserInterfaceStyle = appearanceSetting.userInterfaceStyle
    }
}
