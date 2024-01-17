//
//  LoginValidator.swift
//  orange-stock-ios
//
//  Created by hogang on 2024/01/13.
//

import Foundation

protocol LoginValidateCommand {
    // 로그인 유효성 검사
    func verifyLoginStatus()
    // 로그아웃
    func doLogout()
}

final class LoginValidator {
    
    private var helper: LoginHelper
    private var completion: (Bool) -> Void
    
    // MARK: Init
    
    init(helper: LoginHelper, completion: @escaping (Bool) -> Void) {
        self.helper = helper
        self.completion = completion
    }
    
    convenience init(helper: LoginHelper) {
        self.init(helper: helper) { _ in }
    }
}

// MARK: - LoginValidateCommand

extension LoginValidator: LoginValidateCommand {
    
    func verifyLoginStatus() {
        let data = helper.getLoginUserData()
        helper.verifyLoginStatus(data: data, completion: completion)
    }
    
    func doLogout() {
        helper.doLogout()
        revokeAccessToken()
    }
}

// MARK: - Private Methods

extension LoginValidator {
    
    // accessToken 페기
    private func revokeAccessToken() {
        guard let accessToken = UserDefaultsManager.shared.getAccessToken() else { return }
        OAuthAPIService().revokeAccessToken(accessToken) { _ in }
    }
}
