//
//  SettingViewModel.swift
//  orange-stock-ios
//
//  Created by johyokyeong on 2023/12/26.
//

import UIKit

// MARK: - SettingTableView

enum SettingTableViewType {
    // 화면
    case Appearance // 화면 설정
    
    // 유저
    case Logout // 로그아웃
}

protocol SettingTableViewSection {
    var rows: [SettingTableViewRow] { get }
}

protocol SettingTableViewRow {
    var type: SettingTableViewType { get }
    var title: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
    func didSelected(with viewModel: SettingViewModel)
}

// MARK: Section

private struct SettingAppearanceSection: SettingTableViewSection {
    var rows: [SettingTableViewRow] = [SettingAppearanceRow()]
}

private struct SettingUserInfoSection: SettingTableViewSection {
    var rows: [SettingTableViewRow] = [SettingLogoutRow()]
}

// MARK: Row

private struct SettingAppearanceRow: SettingTableViewRow {
    var type: SettingTableViewType = .Appearance
    var title: String = "화면설정"
    var accessory: UITableViewCell.AccessoryType = .disclosureIndicator
    func didSelected(with viewModel: SettingViewModel) {
        viewModel.pushViewController.value = AppearanceSettingViewController()
    }
}

private struct SettingLogoutRow: SettingTableViewRow {
    var type: SettingTableViewType = .Logout
    var title: String = "로그아웃"
    var accessory: UITableViewCell.AccessoryType = .none
    func didSelected(with viewModel: SettingViewModel) {
        viewModel.showLogoutAlert.value = true
    }
}

// MARK: - SettingViewModel

protocol SettingViewModelInput {
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
    func cellForRowAt(_ indexPath: IndexPath) -> SettingTableViewRow
    /// didSelectRowAt
    func didSelectRow(at indexPath: IndexPath)
}

final class SettingViewModel {
    
    // MARK: Properties
    
    private let sections: [SettingTableViewSection] = [
        SettingAppearanceSection(),
        SettingUserInfoSection()
    ]
    var showLogoutAlert: Observable<Bool> = Observable(false)
    var pushViewController: Observable<UIViewController?> = Observable(nil)
    
}

// MARK: SettingViewModelInput

extension SettingViewModel: SettingViewModelInput {
    
    func didTouchLogout() {
        // 키체인에서 애플아이디 삭제
        deleteAppleID()
        // 액세스 토큰 폐기
        revokeAccessToken()
    }
}

// MARK: SettingViewModelOutput

extension SettingViewModel: SettingViewModelOutput {
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> SettingTableViewRow {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let rowInfo = sections[indexPath.section].rows[indexPath.row]
        rowInfo.didSelected(with: self)
    }
}

// MARK: Private Methods

extension SettingViewModel {
    
    // MARK: Logout
    /// 키체인에서 애플 아이디 삭제
    private func deleteAppleID() {
        do {
            try KeychainItemManager.delete(account: .appleUserID)
        } catch {
            print("keychain delete appleID error: \(error.localizedDescription)")
        }
    }
    /// access token 폐기
    private func revokeAccessToken() {
        guard let accessToken = UserDefaultsManager.shared.getAccessToken() else { return }
        OAuthAPIService().revokeAccessToken(accessToken) { result in
            switch result {
            case .success(let response):
                if response.code == 200 {
                    print("success")
                } else {
                    print("revokeAccessToken fail with message: \(response.message)")
                }
            case .failure(let error):
                print("revokeAccessToken error: \(error.localizedDescription)")
            }
        }
    }
}
