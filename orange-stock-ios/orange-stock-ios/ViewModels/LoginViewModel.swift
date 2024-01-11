//
//  LoginViewModel.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/19.
//

import Foundation

// MARK: - Enum

enum LoginError: Error {
    /// 유효하지 않은 자격
    case invalidCredentials
    /// 로그인 실패
    case failLogin
}

// MARK: - Protocols

/// Login View Event Input Protocol
protocol LoginViewModelInput {
    /// 애플 로그인 버튼 터치
    func didTouchAppleLoginButton()
}

// MARK: - Class

/// ViewModel: 로그인
final class LoginViewModel {
    
    // MARK: Properties
    /// 로그인 성공 여부
    var isSucceedLogin: Observable<Bool> = Observable(false)
    /// 로그인 에러 메세지
    var errorMessage: Observable<String?> = Observable(nil)
    
    private let helper: AppleLoginHelper
    
    // MARK: Init
    
    init(helper: AppleLoginHelper = AppleLoginHelper()) {
        self.helper = helper
        self.helper.delegate = self
    }
}

// MARK: - LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
    // 애플 로그인 버튼 터치
    func didTouchAppleLoginButton() {
        helper.doLogin()
    }
}

// MARK: - AppleLoginHelperDelegate

extension LoginViewModel: AppleLoginHelperDelegate {
    func didCompleteWith(credential: AppleIDCredential) {
        // 키체인에 userID 저장
        do {
            try KeychainItemManager.save(account: .appleUserID, item: credential.user, isForce: true)
            isSucceedLogin.value = true
        } catch {
            didCompleteWith(error: error)
        }
    }
    
    func didCompleteWith(error: Error) {
        errorMessage.value = error.localizedDescription
    }
}
