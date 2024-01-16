//
//  AppleLoginHelperTests.swift
//  orange-stock-iosTests
//
//  Created by hogang on 2024/01/11.
//

import XCTest
import AuthenticationServices

@testable import orange_stock_ios

final class AppleLoginHelperTests: XCTestCase {
    
    private var helper: AppleLoginHelper!
    private var factory: AppleIDAuthorizationFactory!
    
    override func setUpWithError() throws {
        factory = MockingAppleIDAuthorization()
        helper = AppleLoginHelper(factory: factory)
    }
    
    override func tearDownWithError() throws {
        helper = nil
        factory = nil
    }
    
    // 애플 로그인 프로세스 실행
    func testDoLogin() {
        helper.doLogin()
        if let factory = factory as? MockingAppleIDAuthorization {
            XCTAssertEqual(factory.spy?.callCount, 1, "로그인 프로세스 실행")
        } else {
            XCTFail("모의 객체 생성 실패")
        }
    }
    
    // 애플 로그인 필요 여부 확인 - verifyAppleLoginStatus
    // 이미 로그인 되어있는 경우
    func testLoginStatus() {
        let data = "apple ID".data(using: .utf8)!
        helper.verifyLoginStatus(data: data) { needLogin in
            XCTAssertFalse(needLogin)
        }
    }
    
    // 로그인 정보는 있으나 폐기된 정보일 경우
    func testLoginIDRevokedStatus() {
        let data = "oldAppleID".data(using: .utf8)!
        helper.verifyLoginStatus(data: data) { needLogin in
            XCTAssertTrue(needLogin)
        }
    }
    
    // 로그인 정보가 없다.
    func testLoginIDNotFoundStatus() {
        helper.verifyLoginStatus(data: nil) { needLogin in
            XCTAssertTrue(needLogin)
        }
    }
}

// MARK: - Mock up Data

class MockingAppleIDAuthorization: AppleIDAuthorizationFactory {
    
    var spy: Spy?
    
    class Spy: ASAuthorizationController {
        var callCount = 0
        
        override func performRequests() {
            callCount += 1
        }
    }
    
    func createASAuthorizationController(_ requests: [ASAuthorizationRequest]) -> ASAuthorizationController {
        spy = Spy(authorizationRequests: requests)
        return spy!
    }
    
    func createAppleIDProvider() -> ASAuthorizationAppleIDProvider {
        return MockingASAuthorizationAppleIDProvider()
    }
}

class MockingASAuthorizationAppleIDProvider: ASAuthorizationAppleIDProvider {
    override func getCredentialState(
        forUserID userID: String,
        completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void
    ) {
        if userID.isEmpty {
            completion(.notFound, nil)
        } else if userID == "oldAppleID" {
            completion(.revoked, nil)
        } else {
            completion(.authorized, nil)
        }
    }
}
