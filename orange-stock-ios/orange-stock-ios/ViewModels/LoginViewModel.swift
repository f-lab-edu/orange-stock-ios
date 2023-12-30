//
//  LoginViewModel.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/19.
//

import Foundation
import AuthenticationServices

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

/// Login View Event Output Protocol
protocol LoginViewModelOutput {
    
    /// 로그인 성공 여부
    var isSucceedLogin: Observable<Bool> { get set }
    /// error message
    var errorMessage: Observable<String?> { get set }
    
    /// 애플 로그인 필요 여부 확인
    func isNeedAppleLogin(completion: @escaping (Bool) -> Void)
    /// 애플 로그인 버튼 생성
    func makeAppleLoginButton() -> UIControl
    
    /// 애플 로그인 성공
    func didCompleteAuthentication(userID: String)
    /// 애플 로그인 실패
    func didCompleteWith(error: Error)
}

// MARK: - Class

/// ViewModel: 로그인
/// 애플 로그인 구현으로 인해 NSObject 상속 (UIViewController는 UIResponder를 상속받는데 이게 NSObject를 상속받기 때문)
final class LoginViewModel: NSObject {
    
    // MARK: Properties
    var isSucceedLogin: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    private var authorizationController: ASAuthorizationController!
    
    // MARK: Init
    
    init(authorizationController: ASAuthorizationController) {
        super.init()
        self.authorizationController = authorizationController
        self.authorizationController.delegate = self
    }
    
    convenience override init() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        self.init(authorizationController: authorizationController)
    }
    
    // MARK: Private Methods
    /// 키체인에 저장된 애플 유저 아이디
    private func getAppleUserID() -> String {
        do {
            let userID: String = try KeychainItemManager.read(account: .appleUserID)
            return userID
        } catch {
            return ""
        }
    }
    /// 로그인 성공 후 애플 유저 아이디 저장
    private func saveAppleUserID(_ userID: String) -> Bool {
        guard userID.count > 0 else {
            didCompleteWith(error: LoginError.invalidCredentials)
            return false
        }
        do {
            try KeychainItemManager.save(account: .appleUserID, item: userID)
            return true
        } catch {
            didCompleteWith(error: error)
            return false
        }
    }
    
    /// 화면 설정에 따른 애플 로그인 버튼 스타일
    private func appleLoginButtonStyle() -> ASAuthorizationAppleIDButton.Style {
        AppearanceManager.shared.appearanceSetting.userInterfaceStyle == .dark ? .white : .black
    }
}

// MARK: - LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
    // 애플 로그인 버튼 터치
    func didTouchAppleLoginButton() {
        // 애플 로그인 프로세스 실행
        self.authorizationController.performRequests()
    }
}

// MARK: - LoginViewModelOutput

extension LoginViewModel: LoginViewModelOutput {

    func isNeedAppleLogin(completion: @escaping (Bool) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: getAppleUserID()) { (credentialState, error) in
            completion(credentialState == .revoked || credentialState == .notFound)
        }
    }
    
    func makeAppleLoginButton() -> UIControl {
        let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: appleLoginButtonStyle())
        return appleLoginButton
    }
    
    func didCompleteAuthentication(userID: String) {
        // 키체인에 userID 저장
        isSucceedLogin.value = saveAppleUserID(userID)
    }
    
    func didCompleteWith(error: Error) {
        errorMessage.value = error.localizedDescription
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            didCompleteAuthentication(userID: appleIDCredential.user)
        } else {
            didCompleteWith(error: LoginError.invalidCredentials)
        }
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        didCompleteWith(error: LoginError.failLogin)
    }
}
