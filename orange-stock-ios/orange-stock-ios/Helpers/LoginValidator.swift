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
}

final class LoginValidator: LoginValidateCommand {
    
    private var helper: LoginHelper
    private var completion: (Bool) -> Void
    
    init(helper: LoginHelper, completion: @escaping (Bool) -> Void) {
        self.helper = helper
        self.completion = completion
    }
    
    func verifyLoginStatus() {
        let data = helper.getLoginUserData()
        helper.verifyLoginStatus(data: data, completion: completion)
    }
}
