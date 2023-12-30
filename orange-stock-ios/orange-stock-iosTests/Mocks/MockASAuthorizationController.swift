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
    /// 로그인 성공 테스트를 위한 delegate
    weak open var mockDelegate:  MockASAuthorizationControllerDelegate?
    
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
        guard let credential = authorization.credential as? AppleIDCredential else {
            return
        }
        completedWith(credential: credential)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        delegate?.authorizationController?(controller: self, didCompleteWithError: error)
    }
    
    func completedWith(credential: AppleIDCredential) {
        mockDelegate?.didCompleteAuthentication(userID: credential.user)
    }
}

// MARK: ASAuthorizationControllerDelegate Mock

protocol MockASAuthorizationControllerDelegate: NSObjectProtocol {
    func didCompleteAuthentication(userID: String)
    func didCompleteWith(error: Error)
}

// MARK: ASAuthorization Mock Data

protocol AppleIDCredential {
    var user: String { get }
}

extension ASAuthorizationAppleIDCredential: AppleIDCredential {}

protocol Authorization {
    var credential: ASAuthorizationCredential { get }
}

struct Credential: AppleIDCredential {
    let user: String
}
