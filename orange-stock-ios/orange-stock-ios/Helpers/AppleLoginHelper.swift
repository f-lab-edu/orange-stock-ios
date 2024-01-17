//
//  AppleLoginHelper.swift
//  orange-stock-ios
//
//  Created by hogang on 2024/01/08.
//

import Foundation
import AuthenticationServices

// MARK: - Protocols
/// Login Helper Protocol
protocol LoginHelper {
    /// 로그인 실행
    func doLogin()
    /// 키체인에 저장된 로그인 관련 데이터
    func getLoginUserData() -> Data?
    /// 로그인 유효성 검사
    func verifyLoginStatus(data: Data?, completion: @escaping (Bool) -> Void)
    /// 로그아웃
    func doLogout()
}

// MARK: - Delegate

protocol AppleLoginHelperDelegate: AnyObject {
    func didCompleteWith(credential: AppleIDCredential)
    func didCompleteWith(error: Error)
}

// MARK: - Class: Apple Login Helper
/// Helper Class - 애플 로그인 관련 프로세스
final class AppleLoginHelper: NSObject {
    
    // MARK: Properties
    
    private let factory: AppleIDAuthorizationFactory
    weak var delegate: AppleLoginHelperDelegate?
    
    // MARK: Init
    
    init(factory: AppleIDAuthorizationFactory = AppleIDAuthorization()) {
        self.factory = factory
    }
}

// MARK: - LoginHelper

extension AppleLoginHelper: LoginHelper {
    /// 로그인 프로세스 실행
    func doLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = self.factory.createASAuthorizationController([request])
        controller.delegate = self
        controller.performRequests()
    }
    
    /// 키체인에 저장된 로그인 관련 데이터
    func getLoginUserData() -> Data? {
        return try? KeychainItemManager.read(account: .appleUserID)
    }
    
    /// 로그인 유효성 확인
    func verifyLoginStatus(data: Data?, completion: @escaping (Bool) -> Void) {
        guard let userData = data else {
            completion(true)
            return
        }
        let userID = String(decoding: userData, as: UTF8.self)
        factory.createAppleIDProvider().getCredentialState(forUserID: userID) { credentialState, _ in
            completion(credentialState == .revoked || credentialState == .notFound)
        }
    }
    
    /// 로그아웃
    func doLogout() {
        try? KeychainItemManager.delete(account: .appleUserID)
    }
}

// MARK: - Static Methods

extension AppleLoginHelper {
    /// 애플 로그인 버튼 생성
    static func makeAppleLoginButton() -> UIControl {
        let appleLoginButton = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: AppearanceManager.shared.appearanceSetting.userInterfaceStyle == .dark
             ? .white
             : .black
        )
        return appleLoginButton
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleLoginHelper: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let credential = authorization.credential as? AppleIDCredential {
            delegate?.didCompleteWith(credential: credential)
        } else {
            delegate?.didCompleteWith(error: LoginError.invalidCredentials)
        }
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        delegate?.didCompleteWith(error: LoginError.failLogin)
    }
}

// MARK: - Credential

protocol AppleIDCredential {
    var user: String { get }
}

extension ASAuthorizationAppleIDCredential: AppleIDCredential { }


// MARK: - AuthorizationControllerFactory

protocol AppleIDAuthorizationFactory {
    /// ASAuthorizationController 객체 생성
    func createASAuthorizationController(_ requests: [ASAuthorizationRequest]) -> ASAuthorizationController
    /// ASAuthorizationAppleIDProvider 객체 생성
    func createAppleIDProvider() -> ASAuthorizationAppleIDProvider
}

final class AppleIDAuthorization: AppleIDAuthorizationFactory {
    func createASAuthorizationController(_ requests: [ASAuthorizationRequest]) -> ASAuthorizationController {
        return ASAuthorizationController(authorizationRequests: requests)
    }
    
    func createAppleIDProvider() -> ASAuthorizationAppleIDProvider {
        return ASAuthorizationAppleIDProvider()
    }
}
