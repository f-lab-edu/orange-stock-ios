//
//  StockItemListAPI.swift
//  orange-stock-ios
//
//  Created by hogang on 2/14/24.
//

import Foundation
import Moya

/// 국내 주식 종목 조회
enum StockItemListAPI {
    case retrieveStockItemList
}

extension StockItemListAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: NetworkConfig.baseURL)!
    }
    
    var path: String {
        return "/stock/etc"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: parameter ?? [:],
                                  encoding: JSONEncoding.default)
    }
    
    var headers: [String: String]? {
        return [
            "content-type": "application/json; charset=utf-8",
            "tr_cd": trCode, // 거래CD
            "tr_cont": "N", // 연속 거래 여부
            "tr_cont_key": "", // 연속일 경우 그전에 내려온 연속키 값 올림
            "mac_address": ""
        ]
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .retrieveStockItemList:
            return [
                "\(trCode)InBlock": [
                    "gubun": "0" //     구분(0:전체1:코스피2:코스닥)
                ]
            ]
        }
    }
}

extension StockItemListAPI {
    var validationType: ValidationType {
        return .successCodes
    }
}

extension StockItemListAPI {
    var trCode: String {
        switch self {
        case .retrieveStockItemList:
            return "t8436"
        }
    }
}

// MARK: - Mockup Data

extension StockItemListAPI {
    var sampleData: Data {
        sampleJsonString.data(using: .utf8)!
    }
    
    var sampleJsonString: String {
        switch self {
        case .retrieveStockItemList:
            return """
{\"t8436OutBlock\":\
[\
{\"hname\":\"대한항공\",\"shcode\":\"003490\",\"expcode\":\"KR7003490000\",\"etfgubun\":\"0\"\
,\"uplmtprice\":29750,\"dnlmtprice\":16050,\"jnilclose\":22900,\"memedan\":\"00001\",\"recprice\":22900\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"대한항공우\",\"shcode\":\"003495\",\"expcode\":\"KR7003491008\",\"etfgubun\":\"0\"\
,\"uplmtprice\":33400,\"dnlmtprice\":18000,\"jnilclose\":25700,\"memedan\":\"00001\",\"recprice\":25700\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"영진약품\",\"shcode\":\"003520\",\"expcode\":\"KR7003520004\",\"etfgubun\":\"0\"\
,\"uplmtprice\":2625,\"dnlmtprice\":1415,\"jnilclose\":2020,\"memedan\":\"00001\",\"recprice\":2020\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"한화투자증권\",\"shcode\":\"003530\",\"expcode\":\"KR7003530003\",\"etfgubun\":\"0\"\
,\"uplmtprice\":5920,\"dnlmtprice\":3190,\"jnilclose\":4555,\"memedan\":\"00001\",\"recprice\":4555\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"한화투자증권우\",\"shcode\":\"003535\",\"expcode\":\"KR7003531001\",\"etfgubun\":\"0\"\
,\"uplmtprice\":13650,\"dnlmtprice\":7350,\"jnilclose\":10500,\"memedan\":\"00001\",\"recprice\":10500\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"대신증권\",\"shcode\":\"003540\",\"expcode\":\"KR7003540002\",\"etfgubun\":\"0\"\
,\"uplmtprice\":20300,\"dnlmtprice\":10940,\"jnilclose\":15620,\"memedan\":\"00001\",\"recprice\":15620\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"대신증권우\",\"shcode\":\"003545\",\"expcode\":\"KR7003541000\",\"etfgubun\":\"0\"\
,\"uplmtprice\":18830,\"dnlmtprice\":10150,\"jnilclose\":14490,\"memedan\":\"00001\",\"recprice\":14490\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"},\
{\"hname\":\"대신증권2우B\",\"shcode\":\"003547\",\"expcode\":\"KR7003542008\",\"etfgubun\":\"0\"\
,\"uplmtprice\":17920,\"dnlmtprice\":9660,\"jnilclose\":13790,\"memedan\":\"00001\",\"recprice\":13790\
,\"gubun\":\"1\",\"bu12gubun\":\"01\",\"spac_gubun\":\"N\",\"filler\":\"\"}],\"rsp_cd\":\"00000\"\
,\"rsp_msg\":\"정상적으로 조회가 완료되었습니다.\"}
"""
        }
    }
}
