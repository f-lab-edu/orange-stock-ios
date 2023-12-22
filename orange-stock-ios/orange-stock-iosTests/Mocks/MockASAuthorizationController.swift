//
//  MockASAuthorizationController.swift
//  orange-stock-iosTests
//
//  Created by hogang on 2023/12/21.
//

import Foundation
import AuthenticationServices

/// 애플 로그인 테스트를 위한 구현체
class MockASAuthorizationController: ASAuthorizationController {
    
    // MARK: Properties
    
    /// 프로세스 실행 호출 횟수
    var performRequestsCallCount = 0
    
    // MARK: Init
    
    override init(authorizationRequests: [ASAuthorizationRequest]) {
        super.init(authorizationRequests: authorizationRequests)
    }
    
    convenience init() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        self.init(authorizationRequests: [request])
    }
    
    // MARK: Public Methods
    
    override func performRequests() {
        performRequestsCallCount += 1
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        delegate?.authorizationController?(controller: self, didCompleteWithAuthorization: authorization)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        delegate?.authorizationController?(controller: self, didCompleteWithError: error)
    }
}
