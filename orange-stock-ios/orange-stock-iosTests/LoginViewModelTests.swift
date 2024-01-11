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
    
    private var factory: AppleIDAuthorizationFactory!
    private var helper: AppleLoginHelper!
    private var vm: LoginViewModel!
    
    override func setUpWithError() throws {
        factory = MockingAppleIDAuthorization()
        helper = AppleLoginHelper(factory: factory)
        vm = LoginViewModel(helper: helper)
    }
    
    override func tearDownWithError() throws {
        factory = nil
        helper = nil
        vm = nil
    }
    
    // 애플 로그인 버튼 터치
    func test_didTouchAppleLoginButton() {
        vm.didTouchAppleLoginButton()
        if let factory = factory as? MockingAppleIDAuthorization {
            XCTAssertEqual(factory.spy?.callCount, 1, "로그인 프로세스 실행")
        } else {
            XCTFail("모의 객체 생성 실패")
        }
    }
    
    // 애플 로그인 성공 시
    func test_didAppleLoginSuccess() {
        let credential = MockingCredential(user: "apple ID")
        helper.delegate?.didCompleteWith(credential: credential)
        XCTAssertTrue(vm.isSucceedLogin.value)
    }
    
    // 애플 로그인 실패
    func test_didAppleLoginCompleteWithError() {
        helper.delegate?.didCompleteWith(error: LoginError.failLogin)
        XCTAssertEqual(LoginError.failLogin.localizedDescription, vm.errorMessage.value)
    }
}

struct MockingCredential: AppleIDCredential {
    let user: String
}

