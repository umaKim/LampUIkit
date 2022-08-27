//
//  NetworkService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/17.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private let baseUrl = "https://dev.twolamps.shop"
    private var token: String = "asdf7834kj189ad8zjhkj3qthq5"
    
    public func setToken(_ uid: String) {
        self.token = uid
    }
    
    func login() {
        let requestUrl = baseUrl + "/app/users"
        let parameters = LoginUserData(email: "yk@gmail.com",
                                       nickname: "trump",
                                       name: "pppName",
                                       socialToken: "YK_Social",
                                       isAdmin: false)
        
        AF.request(requestUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                print(response)
            }
    }
    
    func checkUserExist(_ uid: String, completion: @escaping (UserExistCheckResponse) -> Void) {
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
    
    func deleteUser(completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/delete?token=\(token)"
        
        AF.request( requestUrl, method: .delete )
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func fetchRecommendation(
        _ location: Location,
        _ radius: Int,
        _ numberOfItems: Int = 10,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        
        let requestUrl = baseUrl + "/app/main/placeInfo?serviceLanguage=KorService&contentTypeId=12&pageSize=\(numberOfItems)&pageNumber=1&mapX=\(location.lat)&mapY=\(location.long)&radius=\(radius)&token=" + token
        
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
    
    func postAnswers(_ answers: [UserQuizeAnswer], completion: @escaping (Result<Response, AFError>) -> Void) {
        
        let requestUrl = baseUrl + "/app/users/survey?token=\(token)"
        
        AF.request(requestUrl, method: .post, parameters: answers, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func postNickName(_ nickName: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let parameters = NickNameSettingData(nickname: nickName, socialToken: token, isAdmin: 0)
        
        let requestUrl = baseUrl + "/app/users"
        
        AF.request(requestUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func fetchLocationDetail(_ contentId: String, _ contentTypeId: String, completion: @escaping (Result<LocationDetailResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/main/placeInfo/detail?serviceLanguage=KorService&contentTypeId=\(contentTypeId)&pageSize=4&pageNumber=1&contentId=\(contentId)&token=\(token)"
        print(requestUrl)
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LocationDetailResponse.self) { response in
                print(String(decoding: response.data!, as: UTF8.self))
                completion(response.result)
            }
    }
    
    func postReview(_ parameters: ReviewPostData, completion: @escaping (Result<Response, AFError>) -> Void) {
        
        var newParameters = parameters
        newParameters.token = token
        
        let requestUrl = baseUrl + "/app/placeInfo/review"
        
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

        print(dateFormatter.string(from: date))
        let dateString = dateFormatter.string(from: date)

        let requestUrl = baseUrl + "/app/placeInfo/review/photo?contentId=\(contentId)&userId=\(token)&date=\(dateString)"
        
        print(requestUrl)
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
    
    func fetchSearchLocations(
        _ keyword: String,
        page: Int = 20,
        pageNumber: Int = 1,
        completion: @escaping (Result<RecommendedLocationResponse, AFError>) -> Void
    ) {
        guard
            let encodedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {return }
        
        let requestUrl = baseUrl + "/app/main/placeInfo/keyword?serviceLanguage=KorService&keyword=\(encodedString)&pageSize=\(page)&pageNumber=\(pageNumber)&token=\(token)"
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
        
        AF.request(requestUrl, method: .post, parameters: newParameter, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
                completion(response.result)
            }
    }
    
    func deleteFromMyTravel(_ planIdx: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip?token=\(token)&planIdx=\(planIdx)"
        
        AF.request(requestUrl, method: .delete, headers: nil)
            .validate()
            .responseDecodable(of: Response.self) { response in
//                completion(response.result)
//                print(String(decoding: response.data!, as: UTF8.self))
                completion(response.result)
            }
    }
    
    func fetchMyTravel(completion: @escaping (Result<[MyTravelLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip?token=\(token)"
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyTravelLocation].self) { response in
                completion(response.result)
            }
    }
    
    func removeMyTravel(_ item: MyTravelLocation) {
        print(item)
        guard let planIdx = item.planIdx else {return }
        let requestUrl = baseUrl + "/app/trip?token=\(token)&planIdx=\(planIdx)"
        
        AF.request(requestUrl, method: .delete)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                print(response)
            }
    }
    
    func fetchSavedTravel(completion: @escaping (Result<[MyTravelLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip/bookmark?token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyTravelLocation].self) { response in
                completion(response.result)
            }
    }
    
    func fetchCompletedTravel(completion: @escaping (Result<[MyTravelLocation], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/trip/complete?token=\(token)"
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [MyTravelLocation].self) { response in
                completion(response.result)
            }
    }
    
    func updateBookMark(of contentId: String, _ mapx: String, _ mapY: String, placeName: String, placeAddr: String, completion: @escaping (Result<Response, AFError>) -> Void) {
        guard
            let encodedPlaceName = placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let encodedPlaceAddr = placeAddr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return }
        
        let requestUrl = baseUrl + "/app/main/placeInfo/bookmark?token=\(token)&contentId=\(contentId)&mapX=\(mapx)&mapY=\(mapY)&placeName=\(encodedPlaceName)&placeAddr=\(encodedPlaceAddr)"
        
        print(requestUrl)
        AF.request(requestUrl, method: .patch)
            .validate()
            .responseDecodable(of: Response.self) {
                response in
                completion(response.result)
            }
    }
    
    func fetchLocationDetailImage(_ contentId: String, completion: @escaping (Result<LocationImageResponse, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/images?contentId=\(contentId)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LocationImageResponse.self) {
                response in
                completion(response.result)
            }
    }
    
    func fetchReviews(_ contentId: String, completion: @escaping (Result<[ReviewData], AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/placeInfo/review?token=\(token)&contentId=\(contentId)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [ReviewData].self) {
                response in
                completion(response.result)
            }
    }
    
    func fetchCharacterInfo(completion: @escaping (Result<MyCharacter, AFError>) -> Void) {
        let requestUrl = baseUrl + "/app/users/myCharacter?token=\(token)"
        
        AF.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: MyCharacter.self) {
                response in
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
}
}
