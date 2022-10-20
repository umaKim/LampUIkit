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
    var recommendedLocationResponse: RecommendedLocationResponse?
    var myTravelLocations: [MyTravelLocation]?
    
    func get<RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where RESPONSE : Decodable {
        switch request {
        case .checkUserExist(let uid):
            if let userExistCheckResponse = userExistCheckResponse {
                completion(.success(userExistCheckResponse as! RESPONSE))
            }
        case .fetchRecommendation(let location, let radius, let numberOfItems):
            if let recommendedLocationResponse = recommendedLocationResponse {
                completion(.success(recommendedLocationResponse as! RESPONSE))
            }
            
        case .fetchRecommendationFromAllOver:
            if let recommendedLocationResponse = recommendedLocationResponse {
                completion(.success(recommendedLocationResponse as! RESPONSE))
            }
            
        case .fetchMyTravel:
            if let myTravelLocations = myTravelLocations {
                completion(.success(myTravelLocations as! RESPONSE))
            }
            
        case .fetchCompletedTravel:
            if let recommendedLocationResponse = recommendedLocationResponse {
                completion(.success(recommendedLocationResponse as! RESPONSE))
            }
            
        default:
            break
        }
    }
    
    func post<PARAMETERS, RESPONSE>(_ request: LampUIKit.URLConfigurator, _ parameter: PARAMETERS, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where PARAMETERS : Encodable, RESPONSE : Decodable {
        
    }
    
    func patch<PARAMETERS, RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, parameters: PARAMETERS?, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where PARAMETERS : Encodable, RESPONSE : Decodable {
        switch request {
        case .fetchCategoryPlaces(.init(lat: 0, long: 0), .art):
            if let recommendedLocationResponse = recommendedLocationResponse {
                completion(.success(recommendedLocationResponse as! RESPONSE))
            }
            
        default:
            break
        }
    }
    
    func delete<RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where RESPONSE : Decodable {
        
    }
    
    func uploadMultipartForm<RESPONSE>(_ request: LampUIKit.URLConfigurator, _ datum: [Data], _ contentId: String, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where RESPONSE : Decodable {
        
    }
}
