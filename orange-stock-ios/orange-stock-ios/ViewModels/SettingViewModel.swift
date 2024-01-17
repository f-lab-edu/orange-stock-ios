//
//  SettingViewModel.swift
//  orange-stock-ios
//
//  Created by johyokyeong on 2023/12/26.
//

import Foundation

// MARK: - Enum

enum TableViewCellAccessoryType {
    case none
    case disclosureIndicator
    case checkmark
}

enum PushViewControllerType {
    case AppearanceSettingViewController
}

// MARK: - Protocols

protocol TableViewCellRowProtocol {
    var title: String { get }
    var accessory: TableViewCellAccessoryType { get }
}

protocol SettingViewModelInput {
    /// didSelectRowAt
    func didSelectRow(at indexPath: IndexPath)
    /// 로그아웃 버튼 터치
    func didTouchLogout()
}

protocol SettingViewModelOutput {
    /// 로그아웃 alert 노출 여부
    var showLogoutAlert: Observable<Bool> { get set }
    /// numberOfSections
    func numberOfSections() -> Int
    /// numberOfRowsInSection
    func numberOfRowsInSection(_ section: Int) -> Int
    /// cellForRowAt
    func rowType(at indexPath: IndexPath) -> TableViewCellRowProtocol?
}

// MARK: - Class

final class SettingViewModel {
    
    // MARK: Properties
    
    var showLogoutAlert: Observable<Bool> = Observable(false)
    var pushViewController: Observable<PushViewControllerType?> = Observable(.none)
    
    // MARK: Enum

    /// Section
    enum Section: Int, CaseIterable {
        case appearnce
        case userinfo
    }

    /// tableView Row
    enum AppearnceRow: Int, CaseIterable, TableViewCellRowProtocol {
        case appearance
        
        var title: String {
            switch self {
            case .appearance:
                return "화면 설정"
            }
        }
        
        var accessory: TableViewCellAccessoryType {
            switch self {
            case .appearance:
                return .disclosureIndicator
            }
        }
        
        var pushViewController: PushViewControllerType {
            switch self {
            case .appearance:
                return .AppearanceSettingViewController
            }
        }
    }

    enum UserInfoRow: Int, CaseIterable, TableViewCellRowProtocol {
        case logout
        
        var title: String {
            switch self {
            case .logout:
                return "로그아웃"
            }
        }
        
        var accessory: TableViewCellAccessoryType {
            switch self {
            case .logout:
                return .none
            }
        }
    }
}

// MARK: SettingViewModelInput

extension SettingViewModel: SettingViewModelInput {
    func didSelectRow(at indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .appearnce:
            pushViewController.value = AppearnceRow(rawValue: indexPath.row)?.pushViewController
        case .userinfo:
            showLogoutAlert.value = true
        case .none:
            break
        }
    }
    
    func didTouchLogout() {
        let loginVaildator = LoginValidator(helper: AppleLoginHelper())
        loginVaildator.doLogout()
    }
}

// MARK: SettingViewModelOutput

extension SettingViewModel: SettingViewModelOutput {
    /// numberOfSections
    func numberOfSections() -> Int {
        Section.allCases.count
    }
    /// numberOfRowsInSection
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch Section(rawValue: section) {
        case .appearnce:
            return AppearnceRow.allCases.count
        case .userinfo:
            return UserInfoRow.allCases.count
        case .none:
            return 0
        }
    }
    ///
    func rowType(at indexPath: IndexPath) -> TableViewCellRowProtocol? {
        switch Section(rawValue: indexPath.section) {
        case .appearnce:
            return AppearnceRow(rawValue: indexPath.row)
        case .userinfo:
            return UserInfoRow(rawValue: indexPath.row)
        case .none:
            return nil
        }
    }
}
