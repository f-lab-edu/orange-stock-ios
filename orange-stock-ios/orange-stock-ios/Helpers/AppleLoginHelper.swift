//
//  AppleLoginHelper.swift
//  orange-stock-ios
//
//  Created by hogang on 2024/01/08.
//

import Foundation
import AuthenticationServices

// MARK: Delegate

protocol AppleLoginHelperDelegate: AnyObject {
    func didCompleteWith(credential: AppleIDCredential)
    func didCompleteWith(error: Error)
}

// MARK: - Class: Apple Login Helper
/// Helper Class - 애플 로그인 관련 프로세스
final class AppleLoginHelper: NSObject {
    
    // MARK: Properties
    
    let factory: AppleIDAuthorizationFactory
    weak var delegate: AppleLoginHelperDelegate?
    
    // MARK: Init
    
    init(factory: AppleIDAuthorizationFactory = AppleIDAuthorization()) {
        self.factory = factory
    }
    
    // MARK: Public Methods
    /// 로그인 프로세스 실행
    func doLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = self.factory.createASAuthorizationController([request])
        controller.delegate = self
        controller.performRequests()
    }
}

// MARK: - Static Methods

extension AppleLoginHelper {
    /// 애플 로그인 필요 여부 확인
    static func verifyAppleLoginStatus(
        factory: AppleIDAuthorizationFactory = AppleIDAuthorization(),
        userID: String?
    ) async throws -> Bool {
        guard let userID = userID else { return true }
        let appleIDProvider = factory.createAppleIDProvider()
        let credentialState = try await appleIDProvider.credentialState(forUserID: userID)
        return credentialState == .revoked || credentialState == .notFound
    }
    
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

extension ASAuthorizationAppleIDCredential: AppleIDCredential {}


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
