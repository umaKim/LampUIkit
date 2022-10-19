//
//  MockNetworkManager.swift
//  LampUIKitTests
//
//  Created by 김윤석 on 2022/10/19.
//
import Alamofire
import Foundation
@testable import LampUIKit

class MockNetworkManager: Networkable {
    var userExistCheckResponse: UserExistCheckResponse?
    
    func get<RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where RESPONSE : Decodable {
        switch request {
        case .checkUserExist(let uid):
            if let userExistCheckResponse = userExistCheckResponse {
                completion(.success(userExistCheckResponse as! RESPONSE))
            } else {
                
            }
            
        default:
            break
        }
    }
    
    func post<PARAMETERS, RESPONSE>(_ request: LampUIKit.URLConfigurator, _ parameter: PARAMETERS, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where PARAMETERS : Encodable, RESPONSE : Decodable {
        
    }
    
    func patch<PARAMETERS, RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, parameters: PARAMETERS?, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where PARAMETERS : Encodable, RESPONSE : Decodable {
        
    }
    
    func delete<RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where RESPONSE : Decodable {
        
    }
    
    func uploadMultipartForm<RESPONSE>(_ request: LampUIKit.URLConfigurator, _ datum: [Data], _ contentId: String, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where RESPONSE : Decodable {
        
    }
}
