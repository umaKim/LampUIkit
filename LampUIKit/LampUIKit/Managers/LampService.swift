//
//  LampService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//
import Alamofire
import Combine
import Foundation

protocol LampAPIRequestable: APIRequestable {
//  func getUsers(for user: String, at page: Int) -> AnyPublisher<Users, APIError>
//  func getUserDetail(for user: String) -> AnyPublisher<GithubUser, APIError>
    func checkUserExist(_ uid: String) -> AnyPublisher<UserExistCheckResponse, APIError>
    
    func handleError(from response: Int) -> APIError
}

extension LampAPIRequestable {
  func handleError(from response: Int) -> APIError {
    guard let lampError = LampResponseError(rawValue: response) else {
      return .unknownError(response)
    }
    
    switch lampError {
    case .notModified:
      return .invalidResponse
    case .validationFailed:
      return .validationError("Limit rate")
    case .serviceUnavailable:
      return .validationError("Service is unavailable")
    }
  }
}

enum LampResponseError: Int {
  case notModified = 304
  case validationFailed = 422
  case serviceUnavailable = 503
}

struct LampService: LampAPIRequestable {
    var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
      self.session = session
    }
    
    func checkUserExist(_ uid: String) -> AnyPublisher<UserExistCheckResponse, APIError> {
        
        guard let request = self.createRequest(from: LampURLRequest.checkUserExist(uid)) else {
            return Fail(error: APIError.invalidRequest).eraseToAnyPublisher()
        }
        
        return self.request(request: request, response: UserExistCheckResponse.self)
    }
}


enum URLConfigurator {
    case checkUserExist(_ uid: String)
    case deleteUser
    case fetchRecommendation(_ location: Location, _ radius: Float, _ numberOfItems: Int)
    case fetchCategoryPlaces(_ location: Location, _ category: CategoryType)
    case fetchRecommendationFromAllOver
    case fetchUnvisitedLocations
    case fetchQuestions
    case postAnswers
    case postNickName
    case fetchLocationDetail(_ contentId: String, _ contentTypeId: String)
    case postReview
    case postReviewImages(_ contentId: String, _ date: String)
    case fetchSearchLocations(_ keyword: String, pageSize: Int, pageNumber: Int)
    case postAddToMyTravel
    case deleteFromMyTravel(_ planIdx: String)
    case fetchMyTravel
    case removeMyTravel(_ planIdx: String)
    case fetchSavedTravel
    case fetchCompletedTravel
    case updateBookMark(_ contentId: String, contentTypeId: String, mapx: String, mapY: String, placeName: String, placeAddr: String)
    case fetchLocationDetailImage(_ contentId: String)
    case fetchReviews(_ contentId: String)
    case fetchCharacterInfo
    case fetchMyInfo
    case fetchMyReviews
    case postCompleteTrip
    case patchLike(_ id: String)
    case postReport(_ id: String)
    case deleteReview(_ reviewIdx: Int)
}

//public func postReviewImages(with images: [Data],
//                      _ contentId: String,
//                      completion: @escaping ((Result<Response, AFError>) -> Void)) {
//
//    let date = Date()
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//
//    let dateString = dateFormatter.string(from: date)
//
//    let requestUrl = baseUrl + "/app/placeInfo/review/photo?contentId=\(contentId)&token=\(token)&date=\(dateString)"
//
//    let boundary = "Boundary-\(UUID().uuidString)"
//    let headers: HTTPHeaders = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
//
//    AF.upload(multipartFormData: { (multipartFormData) in
//        for image in images {
//            multipartFormData.append(image,
//                                     withName: "dev",
//                                     fileName: "\(contentId)-\(UUID().uuidString).jpg",
//                                     mimeType: "image/jpeg")
//        }
//    }, to: requestUrl, headers: headers)
//    .responseDecodable(of: Response.self) { response in
//        completion(response.result)
//    }
//}

extension URLConfigurator: URLRequestable {
    var baseURL: String {
        "https://dev.twolamps.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var token: String {
        AuthManager.shared.token ?? ""
    }
    
    var language: String {
        LanguageManager.shared.languageType.rawValue
    }
    
    var endPoint: String {
        switch self {
        case .checkUserExist(let uid):
            return "/app/users?token=\(uid)"
            
        case .deleteUser:
            return "/app/users/delete?token=\(token)"
            
        case .fetchRecommendation(let location, let radius, let numberOfItems):
            return "/app/main/placeInfo?serviceLanguage=\(language)&pageSize=\(numberOfItems)&pageNumber=1&mapX=\(location.long)&mapY=\(location.lat)&radius=\(radius)&token=\(token)"
            
        case .fetchRecommendationFromAllOver:
            return "/app/main/totalPlaceInfo?serviceLanguage=\(language)&pageSize=20&pageNumber=1&token=\(token)"
            
        case .fetchUnvisitedLocations:
            return "/app/main/placeNotVisited?serviceLanguage=\(language)&pageSize=20&pageNumber=1&token=\(token)"
            
        case .fetchQuestions:
            return "/app/users/survey"
            
        case .postAnswers:
            return "/app/users/survey?token=\(token)"
            
        case .postNickName:
            return "/app/users"
            
        case .fetchLocationDetail(let contentId, let contentTypeId):
            return "/app/main/placeInfo/detail?serviceLanguage=\(language)&contentTypeId=\(contentTypeId)&pageSize=4&pageNumber=1&contentId=\(contentId)&token=\(token)"
            
        case .postReview:
            return "/app/placeInfo/review"
            
        case .postReviewImages:
//            return "/app/placeInfo/review/photo?contentId=\(contentId)&token=\(token)&date=\(dateString)"
            return ""
            
        case .fetchSearchLocations(let keyword, pageSize: let pageSize, pageNumber: let pageNumber):
            let encodedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "/app/main/placeInfo/keyword?serviceLanguage=\(language)&keyword=\(encodedString)&pageSize=\(pageSize)&pageNumber=\(pageNumber)&token=\(token)"
            
        case .postAddToMyTravel:
            return "/app/trip"
            
        case .deleteFromMyTravel(let planIdx):
            return "/app/trip?token=\(token)&planIdx=\(planIdx)"
            
        case .fetchMyTravel:
            return "/app/trip?token=\(token)"
            
        case .removeMyTravel(let planIdx):
            return "/app/trip?token=\(token)&planIdx=\(planIdx)"
            
        case .fetchSavedTravel:
            return "/app/trip/bookmark?token=\(token)"
            
        case .fetchCompletedTravel:
            return "/app/trip/complete?token=\(token)"
            
        case .updateBookMark(let contentId, contentTypeId: let contentTypeId, mapx: let mapx, mapY: let mapY, placeName: let placeName, placeAddr: let placeAddr):
//            guard
                let encodedPlaceName = placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let encodedPlaceAddr = placeAddr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//            else { return }
            return "/app/main/placeInfo/bookmark?token=\(token)&contentId=\(contentId)&contentTypeId=\(contentTypeId)&mapX=\(mapx)&mapY=\(mapY)&placeName=\(encodedPlaceName)&placeAddr=\(encodedPlaceAddr)"
            
        case .fetchLocationDetailImage(let contentId):
            return "/app/placeInfo/images?contentId=\(contentId)&serviceLanguage=\(language)"
            
        case .fetchReviews(let contentId):
            return "/app/placeInfo/review?token=\(token)&contentId=\(contentId)"
            
        case .fetchCharacterInfo:
            return "/app/users/myCharacter?token=\(token)"
            
        case .fetchMyInfo:
            return "/app/users/myPage?token=\(token)"
            
        case .fetchMyReviews:
            return "/app/users/myReviews?token=\(token)"
            
        case .postCompleteTrip:
            return "/app/trip/complete"
            
        case .patchLike(_):
            return "/app/placeInfo/review/like"
            
        case .postReport(_):
            return "/app/placeInfo/review/report"
            
        case .deleteReview(let reviewIdx):
            return "/app/placeInfo/review?token=\(token)&reviewIdx=\(reviewIdx)"
        case .fetchCategoryPlaces(let location, let category):
            return "/app/main/category?pageSize=5&pageNumber=1&mapX=\(location.long)&mapY=\(location.lat)&token=\(token)&category=\(category.rawValue)&serviceLanguage=\(language)"
            
        case .postReviewImages(let contentId, let dateString):
            return "/app/placeInfo/review/photo?contentId=\(contentId)&token=\(token)&date=\(dateString)"
        }
    }
    
    var fullUrl: String {
        return "\(baseURL)" + "\(endPoint)"
    }
    
    var httpBody: Data? {
        nil
    }
    
    var httpHeaders: [String : String]? {
        nil
    }
}

protocol Networkable {
    associatedtype ErrorType: Sendable
    
    func create<PARAMETERS: Encodable, RESPONSE: Decodable>(_ request: URLConfigurator, _ parameter: PARAMETERS, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, ErrorType>) -> Void)
    func read<RESPONSE: Decodable>(_ request: URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, ErrorType>) -> Void)
    func update<PARAMETERS: Encodable, RESPONSE: Decodable>(_ request: URLConfigurator, _ response: RESPONSE.Type, parameters: PARAMETERS?, completion: @escaping (Result<RESPONSE, ErrorType>) -> Void)
    func delete<RESPONSE: Decodable>(_ request: URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, ErrorType>) -> Void)
    func uploadMultipartForm<RESPONSE: Decodable>(_ request: URLConfigurator, _ datum: [Data], _ contentId: String, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, ErrorType>) -> Void)
}

final class NetworkManager: Networkable {
    typealias ErrorType = AFError
    
    static let shared = NetworkManager()
    
    func create<PARAMETERS: Encodable, RESPONSE: Decodable>(_ request: URLConfigurator, _ parameter: PARAMETERS, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, AFError>) -> Void) {
        AF.request(request.fullUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    
    func read<RESPONSE: Decodable>(_ request: URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, AFError>) -> Void) {
        AF.request(request.fullUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    
    func update<PARAMETERS: Encodable, RESPONSE: Decodable>(_ request: URLConfigurator, _ response: RESPONSE.Type, parameters: PARAMETERS?, completion: @escaping (Result<RESPONSE, AFError>) -> Void) {
        AF.request(request.fullUrl, method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    
    func delete<RESPONSE: Decodable>(_ request: URLConfigurator, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, AFError>) -> Void) {
        AF.request(request.fullUrl, method: .delete)
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    
    func uploadMultipartForm<RESPONSE: Decodable>(_ request: URLConfigurator, _ datum: [Data], _ contentId: String, _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, AFError>) -> Void) {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for image in datum {
                multipartFormData.append(image,
                                         withName: "dev",
                                         fileName: "\(contentId)-\(UUID().uuidString).jpg",
                                         mimeType: "image/jpeg")
            }
        }, to: request.fullUrl, headers: headers)
        .responseDecodable(of: response.self) { response in
            completion(response.result)
        }
    }
    
//    private func request<T>(requestURL: URL, response: T.Type) -> AnyPublisher<T, APIError> where T: Codable {
//      return URLSession.shared.dataTaskPublisher(for: requestURL)
//        .tryMap { response in
//          guard let httpResponse = response.response as? HTTPURLResponse else {
//            throw APIError.invalidResponse
//          }
//
//          guard httpResponse.statusCode == 200 else {
//              throw self.handleError(from: httpResponse.statusCode)
//          }
//
//          return response.data
//        }
//        .decode(type: T.self, decoder: JSONDecoder())
//        .mapError({ error in
//          APIError.invalidJson(String(describing: error))
//        })
//        .eraseToAnyPublisher()
//    }
//
//    func handleError(from response: Int) -> APIError {
//      guard let githubError = LampResponseError(rawValue: response) else {
//        return .unknownError(response)
//      }
//
//      switch githubError {
//      case .notModified:
//        return .invalidResponse
//      case .validationFailed:
//        return .validationError("Limit rate")
//      case .serviceUnavailable:
//        return .validationError("Service is unavailable")
//      }
//    }
}
