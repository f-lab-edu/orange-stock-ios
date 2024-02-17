//
//  StockItemListAPIServiceTests.swift
//  orange-stock-iosTests
//
//  Created by hogang on 2/16/24.
//

import XCTest
import Moya

@testable import orange_stock_ios

final class StockItemListAPIServiceTests: XCTestCase {
    
    // MARK: RetrieveStockItemList
    
    /// StockItem JSON Decoding Test
    func testJsonDecodingRetrieveStockItemList() {
        StockItemListAPIService(isStub: true).provider.request(.retrieveStockItemList) { result in
            switch result {
            case let .success(response):
                let result = try? JSONDecoder().decode(StockItemList.self, from: response.data)
                XCTAssertNotNil(result, "StockItemList Decoding Test Fail")
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    /// API Network Fail Test - 500
    func testNetworkResponse500() async {
        let apiService = StockItemListAPIService(isStub: true, sampleStatusCode: 500)
        do {
            _ = try await apiService.retrieveStockItemList()
        } catch {
            XCTAssertNotNil(error, "StockItemList API Response 500 Fail")
        }
    }
}
