//
//  LoginViewModelTests.swift
//  orange-stock-iosTests
//
//  Created by hogang on 2023/12/21.
//

import XCTest
@testable import orange_stock_ios
import AuthenticationServices

final class LoginViewModelTests: XCTestCase {
    
    private var loginVM: LoginViewModel!
    private var authorizationController: MockASAuthorizationController!
    
    override func setUpWithError() throws {
        authorizationController = MockASAuthorizationController()
        loginVM = LoginViewModel(authorizationController: authorizationController)
    }

    override func tearDownWithError() throws {
        loginVM = nil
        authorizationController = nil
    }
    
    /// 애플 로그인 버튼 터치 시 애플 로그인 프로세스 실행
    func test_didTouchAppleLoginButton() {
        loginVM.didTouchAppleLoginButton()
        XCTAssertEqual(authorizationController.performRequestsCallCount, 1, "애플로그인 프로세스가 실행되지 않음")
    }
    
    /// 로그인 성공
    /// 키체인 저장 성공
    func test_login_success_save_keychain_success() {
        loginVM.didCompleteAuthentication(userID: "appleID")
        XCTAssertTrue(loginVM.isSucceedLogin.value, "애플 로그인 성공 후 키체인 저장 성공!")
    }
    
    /// 로그인 실패 - Fail Login
    func test_login_fail_with_failLogin_error() {
        authorizationController.authorizationController(controller: authorizationController, didCompleteWithError: LoginError.failLogin)
        XCTAssertEqual(loginVM.errorMessage.value, LoginError.failLogin.localizedDescription, "애플 로그인 실패 메세지가 다름")
    }
}
