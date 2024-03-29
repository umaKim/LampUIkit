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
    var response: Response?
    
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
            
        case .fetchSearchLocations(let keyword, pageSize: let pagesize, pageNumber: let pagenumber):
            if let recommendedLocationResponse = recommendedLocationResponse {
                completion(.success(recommendedLocationResponse as! RESPONSE))
            }
            
        default:
            break
        }
    }
    
    func post<PARAMETERS, RESPONSE>(_ request: LampUIKit.URLConfigurator, _ parameter: PARAMETERS, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where PARAMETERS : Encodable, RESPONSE : Decodable {
        switch request {
        case .postAddToMyTravel:
            if let response = self.response {
                completion(.success(response as! RESPONSE))
            }
            
        case .postCompleteTrip:
            if let response = self.response {
                completion(.success(response as! RESPONSE))
            }
            
        default:
            break
        }
    }
    
    func patch<PARAMETERS, RESPONSE>(_ request: LampUIKit.URLConfigurator, _ response: RESPONSE.Type, parameters: PARAMETERS?, completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void) where PARAMETERS : Encodable, RESPONSE : Decodable {
        switch request {
        case .fetchCategoryPlaces(let location, let category):
            if let recommendedLocationResponse = recommendedLocationResponse {
                completion(.success(recommendedLocationResponse as! RESPONSE))
            }
            
        case .updateBookMark(let contentId, contentTypeId: let contentTypeId, mapx: let mapx, mapY: let mapy, placeName: let placeName, placeAddr: let placeAddr):
            if let response = self.response {
                completion(.success(response as! RESPONSE))
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
