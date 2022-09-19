//
//  NetworkService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/17.
//

import Alamofire
import Foundation

class JsonNetworkService {
    static let shared = JsonNetworkService()
    
    private let baseURL = "http://api.visitkorea.or.kr/openapi/service/rest/DataLabService/tmapTotalTarItsBroDDList?"
    
    enum Key {
        static let bigData = "0IPKAzuqgRL%2BlJLFKeV4YTkgTV%2B90JKXrqf81CWgLhY%2BmtJBbP61uC7JH%2BiiYAlIfP2cFE7bKY1vmI5MGX45Pg%3D%3D"
    }
    
    func fetchRecomendingPlaces() {
        
        let requestUrl = baseURL + "serviceKey=\(Key.bigData)" + "&MobileOS=ETC" + "&MobileApp=AppTest" + "&baseYm=202106" + "&_type=json"
        
        AF.request(requestUrl, method: .get)
            .validate()
            .responseDecodable(of: RecomendingPlaceResponse.self){ response in
                print(response.result)
            }
    }
}

struct RecomendingPlaceResponse: Codable {
    let responsew: RecomendingPlaceHeader
}

struct RecomendingPlaceHeader: Codable {
    let header: RecomendingPlace
}

struct RecomendingPlace: Codable {
    let responseTime: String
}

enum UserAuthType {
    case kakao
    case firebase
}

final class NetworkService {
    static let shared = NetworkService()
    
    private let baseUrl = "https://dev.twolamps.shop"
    private(set) var token: String = "asdf7834kj189ad8zjhkj3qthq5"
    
    public func setToken(_ uid: String) {
        self.token = uid
    }
    
    private(set) var userAuthType: UserAuthType?
    
    private let language = LanguageManager.shared
    
    func setUserAuthType(_ userAuthType: UserAuthType) {
        self.userAuthType = userAuthType
    }
    
    func login() {
        let requestUrl = baseUrl + "/app/users"
        let parameters = LoginUserData(email: "yk@gmail.com",
                                       nickname: "trump",
                                       name: "pppName",
                                       socialToken: "YK_Social",
                                       isAdmin: false)
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                print(response)
            }
    }
    
    func checkUserExist(_ uid: String, completion: @escaping (UserExistCheckResponse) -> Void) {
        let requestUrl = baseUrl + "/app/users?token=\(uid)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: UserExistCheckResponse.self) { response in
                switch response.result {
                case .success(let res):
                    self.setToken(uid)
                    completion(res)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func deleteUser(completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/delete?token=\(token)"
        print(requestUrl)
        AF.request( requestUrl, method: .patch)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func fetchRecommendation(
        _ location: Location,
        _ radius: Float,
        _ numberOfItems: Int = 10,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        let requestUrl = baseUrl + "/app/main/placeInfo?serviceLanguage=\(language.languageType.rawValue)&pageSize=\(numberOfItems)&pageNumber=1&mapX=\(location.long)&mapY=\(location.lat)&radius=\(radius)&token=" + token
        
        print(requestUrl)
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) { response in
                completion(response.result)
            }
    }
    
    func fetchRecommendationFromAllOver(completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/main/totalPlaceInfo?serviceLanguage=\(language.languageType.rawValue)&pageSize=20&pageNumber=1&token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) {
                response in
                completion(response.result)
            }
    }
    
    func fetchUnvisitedLocations(completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/main/placeNotVisited?serviceLanguage=\(language.languageType.rawValue)&pageSize=20&pageNumber=1&token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) { response in
                completion(response.result)
            }
    }
    
    func fetchQuestions(
        completion: @escaping (Result<[Question], AFError>) -> Void
    ) {
        
        let requestUrl = baseUrl + "/app/users/survey"
        
        print(requestUrl)
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [Question].self) { response in
                completion(response.result)
            }
    }
    
    func postAnswers(_ answers: [UserQuizeAnswer], completion: @escaping (Result<CharacterResponse, AFError>) -> Void) {
        
        let requestUrl = baseUrl + "/app/users/survey?token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: answers, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: CharacterResponse.self) { response in
                completion(response.result)
            }
    }
    
    func postNickName(_ nickName: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let parameters = NickNameSettingData(nickname: nickName, socialToken: token, isAdmin: 0)
        
        let requestUrl = baseUrl + "/app/users"
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func fetchLocationDetail(_ contentId: String, _ contentTypeId: String, completion: @escaping (Result<LocationDetailResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/main/placeInfo/detail?serviceLanguage=\(language.languageType.rawValue)&contentTypeId=\(contentTypeId)&pageSize=4&pageNumber=1&contentId=\(contentId)&token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LocationDetailResponse.self) { response in
                completion(response.result)
            }
    }
    
    func postReview(_ parameters: ReviewPostData, completion: @escaping (Result<Response, AFError>) -> Void) {
        
        var newParameters = parameters
        newParameters.token = token
        let requestUrl = baseUrl + "/app/placeInfo/review"
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: newParameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func postReviewImages(with images: [Data],
                          _ contentId: String,
                          completion: @escaping ((Result<Response, AFError>) -> Void)) {
       
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        
        let requestUrl = baseUrl + "/app/placeInfo/review/photo?contentId=\(contentId)&token=\(token)&date=\(dateString)"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
        
        print(requestUrl)
        AF.upload(multipartFormData: { (multipartFormData) in
            for image in images {
                multipartFormData.append(image,
                                         withName: "dev",
                                         fileName: "\(contentId)-\(UUID().uuidString).jpg",
                                         mimeType: "image/jpeg")
            }
        }, to: requestUrl, headers: headers)
        .responseDecodable(of: Response.self) { response in
            completion(response.result)
        }
    }
    
    func fetchSearchLocations(
        _ keyword: String,
        pageSize: Int = 20,
        pageNumber: Int = 1,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        guard
            let encodedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {return }
        
        let requestUrl = baseUrl + "/app/main/placeInfo/keyword?serviceLanguage=\(language.languageType.rawValue)&keyword=\(encodedString)&pageSize=\(pageSize)&pageNumber=\(pageNumber)&token=\(token)"
        print(requestUrl)
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) { response in
                completion(response.result)
            }
    }
    
    func postAddToMyTravel(_ parameter: PostAddToMyTripData, completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip"
        
        var newParameter = parameter
        newParameter.token = token
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: newParameter, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func deleteFromMyTravel(_ planIdx: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip?token=\(token)&planIdx=\(planIdx)"
        print(requestUrl)
        AF.request(requestUrl, method: .delete)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func fetchMyTravel(completion: @escaping (Result<[MyTravelLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip?token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyTravelLocation].self) { response in
                completion(response.result)
            }
    }
    
    func removeMyTravel(_ item: MyTravelLocation, completion: @escaping () -> Void) {
        let planIdx = item.planIdx
        let requestUrl = baseUrl + "/app/trip?token=\(token)&planIdx=\(planIdx)"
        print(requestUrl)
        AF.request(requestUrl, method: .delete)
            .validate()
            .responseDecodable(of: Response.self) { response in
                print(response)
                completion()
            }
    }
    
    func fetchSavedTravel(completion: @escaping (Result<[MyBookMarkLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip/bookmark?token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyBookMarkLocation].self) { response in
                completion(response.result)
            }
    }
    
    func fetchCompletedTravel(completion: @escaping (Result<[RecommendedLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip/complete?token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [RecommendedLocation].self) { response in
                completion(response.result)
            }
    }
    
    func updateBookMark(of contentId: String, contentTypeId: String, mapx: String, mapY: String, placeName: String, placeAddr: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        guard
            let encodedPlaceName = placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let encodedPlaceAddr = placeAddr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return }
        
        let requestUrl = baseUrl + "/app/main/placeInfo/bookmark?token=\(token)&contentId=\(contentId)&contentTypeId=\(contentTypeId)&mapX=\(mapx)&mapY=\(mapY)&placeName=\(encodedPlaceName)&placeAddr=\(encodedPlaceAddr)"
        print(requestUrl)
        AF.request(requestUrl, method: .patch)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                completion(response.result)
            }
    }
    
    func fetchLocationDetailImage(_ contentId: String, completion: @escaping (Result<LocationImageResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/images?contentId=\(contentId)&serviceLanguage=\(language.languageType.rawValue)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LocationImageResponse.self) {
                response in
                completion(response.result)
            }
    }
    
    func fetchReviews(_ contentId: String, completion: @escaping (Result<[ReviewData], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/review?token=\(token)&contentId=\(contentId)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [ReviewData].self) { response in
                completion(response.result)
            }
    }
    
    func fetchCharacterInfo(completion: @escaping (Result<MyCharacter, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/myCharacter?token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: MyCharacter.self) { response in
                completion( response.result)
            }
    }
    
    func fetchMyInfo(completion: @escaping (Result<MyInfo, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/myPage?token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: MyInfo.self) { response in
                completion(response.result)
            }
    }
    
    func fetchMyReviews(completion: @escaping( Result<[UserReviewData], AFError>) -> Void) {
        let requesUrl = baseUrl + "/app/users/myReviews?token=\(token)"
        print(requesUrl)
        AF.request(requesUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [UserReviewData].self) { response in
                completion(response.result)
            }
    }
    
    func postCompleteTrip(_ param: CompleteTripPostData, completion: @escaping (Result<Response, AFError>) -> Void) {
        var newParameter = param
        newParameter.token = token
        
        let requestUrl = baseUrl + "/app/trip/complete"
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: newParameter, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                completion(response.result)
            }
    }
    
    func patchLike(_ id: String) {
        let param = LikeDataPatch(token: token, targetReviewId: id)
        
        let requestUrl = baseUrl + "/app/placeInfo/review/like"
        print(requestUrl)
        AF.request(requestUrl, method: .patch, parameters: param, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                print(response.result)
            }
    }
    
    func postReport(_ id: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let param = LikeDataPatch(token: token, targetReviewId: id)
        let requestUrl = baseUrl + "/app/placeInfo/review/report"
        print(requestUrl)
        AF.request(requestUrl, method: .post, parameters: param, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func deleteReview(_ reviewIdx: Int, completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/review?token=\(token)&reviewIdx=\(reviewIdx)"
        
        AF.request(requestUrl, method: .delete).validate()
            .responseDecodable(of: Response.self) {
                response in
                completion(response.result)
            }
    }
}

struct LikeDataPatch: Codable {
    let token: String
    let targetReviewId: String
}

struct CompleteTripPostData: Codable {
    var token: String
    let planIdx: String
    let mapX: String
    let mapY: String
}

struct MyInfo: Codable {
    let nickName: String
    let numOfReview: Int
    let numOfPlan: Int
}

struct MyCharacter: Codable {
    let nickName: String
    let points: Int
    let travelExp: Int
    let exploreExp: Int
    let socialExp: Int
    let characterLevel: Int
    let totalExp: Int
    let avgExp: Int
    let characterImageUrl: String
}

struct ReviewData: Codable, Hashable {
    let reviewIdx: Int?
    let contentId: String
    let userId: Int?
    let star: String?
    let satisfaction: Int?
    let mood: Int?
    let surround: Int?
    let foodArea: Int?
    let content: String?
    let createdAt: String?
    let numReported: Int?
    let photoIdx: Int?
    var numLiked: Int
    let reviewILiked: Bool
    let photoUrlArray: [String]?
}

struct LocationImageResponse: Decodable {
    let image: [String]
}

struct ReviewPostData: Codable {
    var token: String
    var contentId: String
    let contentTypeId: String
    let placeName: String
    let starRate: String
    let satisfaction: Int
    let mood: Int
    let surround: Int
    let foodArea: Int
    let content: String
}

struct LocationDetailResponse: Codable {
    let result: LocationDetailData?
}

struct LocationDetailData: Codable {
    let datailInfo: LocationDetailInfoData?
    let contentTypeId: String?
    var bookMark: Bool?
    let totalAvgReviewRate: TotalAvgReviewRate?
    let planExist: PlanExist?
}

struct TotalAvgReviewRate: Codable {
    let AVG: Double?
    let satisfaction: Int?
    let mood: Int?
    let surround: Int?
    let foodArea: Int?
}

struct PlanExist: Codable {
    let planIdx: String?
    let num: Int?
    let isActivated: Bool?
}

struct LocationDetailInfoData: Codable {
    let infocenter: String?
    let parking: String?
    let restdate: String?
    let useseason : String?
    let usetime: String?
    let discountinfo: String?
    let infocenterculture : String?
    let restdateculture: String?
    let usefee: String?
    let usetimeculture : String?
    let eventplace : String?
    let eventstartdate: String?
    let placeinfo: String?
    let playtime: String?
    let usetimefestival: String?
    let infocenterleports: String?
    let openperiod: String?
    let restdateleports: String?
    let usefeeleports: String?
    let usetimeleports: String?
    let infocenterfood: String?
    let firstmenu: String?
    let opentimefood: String?
    let restdatefood: String?
}

struct LcoationDetailRevoewData: Codable {
    let reviewIdx: Int
    let contentId: Int
    let userId: Int
    let star: Double
    let mood: Int
    let surround: Int
    let foodArea: Int
    let content: String
    let createdAt: String
    let numReported: Int
    let numLiked: Int
    let photo: [PhotoUrl]
}

struct PhotoUrl: Codable {
    let photoUrl: String
}

struct NickNameSettingData: Codable {
    let nickname: String
    let socialToken: String
    let isAdmin: Int
}

struct UserQuizeAnswer: Codable {
    let questionId: Int
    let answer: Int
}

struct QuestionsResponse: Codable {
    let result: [Question]
}

struct Question: Codable {
    let surveyIdx: Int
    let title: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let option4: String?
    let option5: String?
}
