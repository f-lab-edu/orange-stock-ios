//
//  APIServiceProviderProtocol.swift
//  orange-stock-ios
//
//  Created by hogang on 2/14/24.
//

import Foundation
import Moya

protocol APIServiceProviderProtocol: AnyObject {
    
    associatedtype T: TargetType
    
    var provider: MoyaProvider<T> { get }
    
    init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((T) -> Endpoint)?)
    
    func request<D: Decodable>(provider: MoyaProvider<T>,
                               target: T,
                               completion: @escaping (Result<D, Error>) -> Void)
}

extension APIServiceProviderProtocol {
    
    func request<D: Decodable>(provider: MoyaProvider<T>,
                               target: T,
                               completion: @escaping (Result<D, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(D.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func createProvider(
        _ isStub: Bool,
        _ sampleStatusCode: Int,
        _ customEndpointClosure: ((T) -> Endpoint)?) -> MoyaProvider<T> {
            if isStub == false {
                return MoyaProvider<T>(
                    session: Session(interceptor: AuthenticatorInterceptor())
                )
            } else {
                // 테스트 시에 호출되는 stub 클로져
                let endPointClosure = { (target: T) -> Endpoint in
                    let sampleResponseClosure: () -> EndpointSampleResponse = {
                        EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                    }
                    
                    return Endpoint(
                        url: URL(target: target).absoluteString,
                        sampleResponseClosure: sampleResponseClosure,
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers
                    )
                }
                return MoyaProvider<T>(
                    endpointClosure: customEndpointClosure ?? endPointClosure,
                    stubClosure: MoyaProvider.immediatelyStub
                )
            }
        }
}
