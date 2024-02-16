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
    
    /// API 호출 테스트
    func testRequestAPIRetrieveStockItemList() {
        var resultOfTask: StockItemList?
        let expectationTest = XCTestExpectation(description: "request")
        
        StockItemListAPIService().retrieveStockItemList { result in
            switch result {
            case .success(let stockItemList):
                resultOfTask = stockItemList
            case .failure(let error):
                print(error.localizedDescription)
            }
            expectationTest.fulfill()
        }
        wait(for: [expectationTest], timeout: 5.0)
        XCTAssertNotNil(resultOfTask, "StockItmeList API Request Fail")
    }
    
    /// API Network Fail Test - 500
    func testNetworkResponse500() {
        let apiService = StockItemListAPIService(isStub: true, sampleStatusCode: 500)
        apiService.retrieveStockItemList { result in
            switch result {
            case .success(let stockItemList):
                XCTAssertNil(stockItemList)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}
