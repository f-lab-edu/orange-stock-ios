//
//  ResponseMessageProtocol.swift
//  orange-stock-ios
//
//  Created by hogang on 2/16/24.
//

import Foundation

protocol ResponseMessageProtocol: Codable {
    
    associatedtype T: Codable
    
    var code: String? { get set }
    var message: String? { get set }
    var items: [T]? { get set }
}
