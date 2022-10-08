//
//  NetworkService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/17.
//

import Alamofire
import Foundation

protocol Networkable {
    func setToken(_ uid: String)
    
    func checkUserExist(_ uid: String, completion: @escaping (UserExistCheckResponse) -> Void)
    
    func deleteUser(completion: @escaping (Result<Response, AFError>) -> Void)
    
    func fetchRecommendation(
        _ location: Location,
        _ radius: Float,
        _ numberOfItems: Int,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    )
    
    func fetchRecommendationFromAllOver(completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void)
    
    func fetchUnvisitedLocations(completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void)
    
    func fetchQuestions(
        completion: @escaping (Result<[Question], AFError>) -> Void
    )
    
    func postAnswers(
        _ answers: [UserQuizeAnswer],
        completion: @escaping (Result<CharacterResponse, AFError>) -> Void
    )
    
    func postNickName(
        _ nickName: String,
        completion: @escaping (Result<Response, AFError>) -> Void
    )
    
    func fetchLocationDetail(
        _ contentId: String,
        _ contentTypeId: String,
        completion: @escaping (Result<LocationDetailResponse, AFError>) -> Void
    )
    
    func postReview(_ parameters: ReviewPostData, completion: @escaping (Result<Response, AFError>) -> Void)
    
    func postReviewImages(with images: [Data],
                   _ contentId: String,
                   completion: @escaping ((Result<Response, AFError>) -> Void))
    
    func fetchSearchLocations(
        _ keyword: String,
        pageSize: Int,
        pageNumber: Int,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    )
    
    func postAddToMyTravel(_ parameter: PostAddToMyTripData, completion: @escaping (Result<Response, AFError>) -> Void)
    
    func deleteFromMyTravel(_ planIdx: String, completion: @escaping (Result<Response, AFError>) -> Void)
    
    func fetchMyTravel(completion: @escaping (Result<[MyTravelLocation], AFError>) -> Void)
    
    func removeMyTravel(_ item: MyTravelLocation, completion: @escaping () -> Void)
    
    func fetchSavedTravel(completion: @escaping (Result<[MyBookMarkLocation], AFError>) -> Void)
    
    func fetchCompletedTravel(completion: @escaping (Result<[RecommendedLocation], AFError>) -> Void)
    
    func updateBookMark(of contentId: String, contentTypeId: String, mapx: String, mapY: String, placeName: String, placeAddr: String, completion: @escaping (Result<Response, AFError>) -> Void)
    
    func fetchLocationDetailImage(_ contentId: String, completion: @escaping (Result<LocationImageResponse, AFError>) -> Void)
    
    func fetchReviews(_ contentId: String, completion: @escaping (Result<[ReviewData], AFError>) -> Void)
    
    func fetchCharacterInfo(completion: @escaping (Result<MyCharacter, AFError>) -> Void)
    
    func fetchMyInfo(completion: @escaping (Result<MyInfo, AFError>) -> Void)
    
    func fetchMyReviews(completion: @escaping( Result<[UserReviewData], AFError>) -> Void)
    
    func postCompleteTrip(_ param: CompleteTripPostData, completion: @escaping (Result<Response, AFError>) -> Void)
    
    func patchLike(_ id: String)
    
    func postReport(_ id: String, completion: @escaping (Result<Response, AFError>) -> Void)
    
    func deleteReview(_ reviewIdx: Int, completion: @escaping (Result<Response, AFError>) -> Void)
}

final class NetworkManager: Networkable {
    static let shared = NetworkManager()
    
    private let baseUrl = "https://dev.twolamps.shop"
    private(set) var token: String = ""
    
    private let language = LanguageManager.shared
    
    public func setToken(_ uid: String) {
        self.token = uid
    }
    
    public func checkUserExist(_ uid: String, completion: @escaping (UserExistCheckResponse) -> Void) {
        let requestUrl = baseUrl + "/app/users?token=\(uid)"
        
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
    
    public func deleteUser(completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/delete?token=\(token)"
        
        AF.request( requestUrl, method: .patch)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    public func fetchRecommendation(
        _ location: Location,
        _ radius: Float,
        _ numberOfItems: Int = 10,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        let requestUrl = baseUrl + "/app/main/placeInfo?serviceLanguage=\(language.languageType.rawValue)&pageSize=\(numberOfItems)&pageNumber=1&mapX=\(location.long)&mapY=\(location.lat)&radius=\(radius)&token=" + token
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) { response in
                completion(response.result)
            }
    }
    
    public func fetchCategoryPlaces(
        _ location: Location,
        _ category: CategoryType,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        let requestUrl = baseUrl +  "/app/main/category?pageSize=5&pageNumber=1&mapX=\(location.long)&mapY=\(location.lat)&token=\(token)&category=\(category.rawValue)&serviceLanguage=\(language.languageType.rawValue)"
        
        AF.request(requestUrl, method: .patch, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) {response in
                completion(response.result)
            }
    }
    
    public func fetchRecommendationFromAllOver(completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/main/totalPlaceInfo?serviceLanguage=\(language.languageType.rawValue)&pageSize=20&pageNumber=1&token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) {
                response in
                completion(response.result)
            }
    }
    
    
    public func fetchUnvisitedLocations(completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/main/placeNotVisited?serviceLanguage=\(language.languageType.rawValue)&pageSize=20&pageNumber=1&token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) { response in
                completion(response.result)
            }
    }
    
    public func fetchQuestions(
        completion: @escaping (Result<[Question], AFError>) -> Void
    ) {
        
        let requestUrl = baseUrl + "/app/users/survey"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [Question].self) { response in
                completion(response.result)
            }
    }
    
    public func postAnswers(
        _ answers: [UserQuizeAnswer],
        completion: @escaping (Result<CharacterResponse, AFError>) -> Void
    ) {
        let requestUrl = baseUrl + "/app/users/survey?token=\(token)"
        
        AF.request(requestUrl, method: .post, parameters: answers, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: CharacterResponse.self) { response in
                completion(response.result)
            }
    }
    
    public func postNickName(
        _ nickName: String,
        completion: @escaping (Result<Response, AFError>) -> Void
    ) {
        let parameters = NickNameSettingData(nickname: nickName, socialToken: token, isAdmin: 0)
        
        let requestUrl = baseUrl + "/app/users"
        
        AF.request(requestUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    public func fetchLocationDetail(
        _ contentId: String,
        _ contentTypeId: String,
        completion: @escaping (Result<LocationDetailResponse, AFError>) -> Void
    ) {
        let requestUrl = baseUrl + "/app/main/placeInfo/detail?serviceLanguage=\(language.languageType.rawValue)&contentTypeId=\(contentTypeId)&pageSize=4&pageNumber=1&contentId=\(contentId)&token=\(token)"
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LocationDetailResponse.self) { response in
                completion(response.result)
            }
    }
    
    public func postReview(_ parameters: ReviewPostData, completion: @escaping (Result<Response, AFError>) -> Void) {
        
        var newParameters = parameters
        newParameters.token = token
        let requestUrl = baseUrl + "/app/placeInfo/review"
        
        AF.request(requestUrl, method: .post, parameters: newParameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    public func postReviewImages(with images: [Data],
                          _ contentId: String,
                          completion: @escaping ((Result<Response, AFError>) -> Void)) {
       
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        
        let requestUrl = baseUrl + "/app/placeInfo/review/photo?contentId=\(contentId)&token=\(token)&date=\(dateString)"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
        
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
    
    public func fetchSearchLocations(
        _ keyword: String,
        pageSize: Int = 20,
        pageNumber: Int = 1,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        guard
            let encodedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {return }
        
        let requestUrl = baseUrl + "/app/main/placeInfo/keyword?serviceLanguage=\(language.languageType.rawValue)&keyword=\(encodedString)&pageSize=\(pageSize)&pageNumber=\(pageNumber)&token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: RecommendedLocationResponse.self) { response in
                completion(response.result)
            }
    }
    
    public func postAddToMyTravel(_ parameter: PostAddToMyTripData, completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip"
        
        var newParameter = parameter
        newParameter.token = token
        
        AF.request(requestUrl, method: .post, parameters: newParameter, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    public func deleteFromMyTravel(_ planIdx: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip?token=\(token)&planIdx=\(planIdx)"
        
        AF.request(requestUrl, method: .delete)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    public func fetchMyTravel(completion: @escaping (Result<[MyTravelLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip?token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyTravelLocation].self) { response in
                completion(response.result)
            }
    }
    
    public func removeMyTravel(_ item: MyTravelLocation, completion: @escaping () -> Void) {
        let planIdx = item.planIdx
        let requestUrl = baseUrl + "/app/trip?token=\(token)&planIdx=\(planIdx)"
        
        AF.request(requestUrl, method: .delete)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion()
            }
    }
    
    public func fetchSavedTravel(completion: @escaping (Result<[MyBookMarkLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip/bookmark?token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyBookMarkLocation].self) { response in
                completion(response.result)
            }
    }
    
    public func fetchCompletedTravel(completion: @escaping (Result<[RecommendedLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip/complete?token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [RecommendedLocation].self) { response in
                completion(response.result)
            }
    }
    
    public func updateBookMark(of contentId: String, contentTypeId: String, mapx: String, mapY: String, placeName: String, placeAddr: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        guard
            let encodedPlaceName = placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let encodedPlaceAddr = placeAddr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return }
        
        let requestUrl = baseUrl + "/app/main/placeInfo/bookmark?token=\(token)&contentId=\(contentId)&contentTypeId=\(contentTypeId)&mapX=\(mapx)&mapY=\(mapY)&placeName=\(encodedPlaceName)&placeAddr=\(encodedPlaceAddr)"
       
        AF.request(requestUrl, method: .patch)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                completion(response.result)
            }
    }
    
    public func fetchLocationDetailImage(_ contentId: String, completion: @escaping (Result<LocationImageResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/images?contentId=\(contentId)&serviceLanguage=\(language.languageType.rawValue)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LocationImageResponse.self) {
                response in
                completion(response.result)
            }
    }
    
    public func fetchReviews(_ contentId: String, completion: @escaping (Result<[ReviewData], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/review?token=\(token)&contentId=\(contentId)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [ReviewData].self) { response in
                completion(response.result)
            }
    }
    
    public func fetchCharacterInfo(completion: @escaping (Result<MyCharacter, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/myCharacter?token=\(token)"
       
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: MyCharacter.self) { response in
                completion( response.result)
            }
    }
    
    public func fetchMyInfo(completion: @escaping (Result<MyInfo, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/myPage?token=\(token)"
       
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: MyInfo.self) { response in
                completion(response.result)
            }
    }
    
    public func fetchMyReviews(completion: @escaping( Result<[UserReviewData], AFError>) -> Void) {
        let requesUrl = baseUrl + "/app/users/myReviews?token=\(token)"
        
        AF.request(requesUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [UserReviewData].self) { response in
                completion(response.result)
            }
    }
    
    public func postCompleteTrip(_ param: CompleteTripPostData, completion: @escaping (Result<Response, AFError>) -> Void) {
        var newParameter = param
        newParameter.token = token
        
        let requestUrl = baseUrl + "/app/trip/complete"
        
        AF.request(requestUrl, method: .post, parameters: newParameter, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                completion(response.result)
            }
    }
    
    public func patchLike(_ id: String) {
        let param = LikeDataPatch(token: token, targetReviewId: id)
        let requestUrl = baseUrl + "/app/placeInfo/review/like"
        
        AF.request(requestUrl, method: .patch, parameters: param, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
            }
    }
    
    public func postReport(_ id: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let param = LikeDataPatch(token: token, targetReviewId: id)
        let requestUrl = baseUrl + "/app/placeInfo/review/report"
        
        AF.request(requestUrl, method: .post, parameters: param, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    public func deleteReview(_ reviewIdx: Int, completion: @escaping (Result<Response, AFError>) -> Void) {
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
