//
//  StockItemListAPIService.swift
//  orange-stock-ios
//
//  Created by hogang on 2/14/24.
//

import Foundation
import Moya

/// 주식 종목 조회 API 호출
final class StockItemListAPIService: APIServiceProviderProtocol {
    
    typealias T = StockItemListAPI
    
    var provider: MoyaProvider<T>
    
    init(isStub: Bool = false,
         sampleStatusCode: Int = 200,
         customEndpointClosure: ((T) -> Moya.Endpoint)? = nil) {
        provider = Self.createProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
    
    // 주식 종목 조회 API
    func retrieveStockItemList() async throws -> StockItemList {
        do {
            return try await asyncRequest(
                provider: provider,
                target: .retrieveStockItemList
            )
        } catch {
            throw error
        }
    }
}
