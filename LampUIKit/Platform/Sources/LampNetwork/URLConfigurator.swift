//
//  URLConfigurator.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//
import LanguageManager
import AuthManager
import Foundation

public struct Location: Equatable {
    public let lat: Double
    public let long: Double
    public init(
        lat: Double,
        long: Double
    ) {
        self.lat = lat
        self.long = long
    }
}

public enum CategoryType: String {
    case history = "HISTORY"
    case nature = "NATURE"
    case art = "ART"
    case activity = "ACTIVITY"
    case food = "FOOD"
}

public enum URLConfigurator {
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
    case myTravel(_ planIdx: String)
    case fetchMyTravel
    case removeMyTravel(_ planIdx: String)
    case fetchSavedTravel
    case fetchCompletedTravel
    case updateBookMark(_ contentId: String, contentTypeId: String, mapX: String, mapY: String, placeName: String, placeAddr: String)
    case fetchLocationDetailImage(_ contentId: String)
    case fetchReviews(_ contentId: String)
    case fetchCharacterInfo
    case fetchMyInfo
    case fetchMyReviews
    case postCompleteTrip
    case patchLike
    case postReport
    case deleteReview(_ reviewIdx: Int)
}

extension URLConfigurator: URLRequestable {
    public var baseURL: String {
        "https://dev.twolamps.shop"
    }
    private var token: String {
        AuthManager.shared.token ?? ""
    }
    private var language: String {
        LanguageManager.shared.languageType.rawValue
    }
    public var endPoint: String {
        switch self {
        case .checkUserExist(let uid):
            return "/app/users?token=\(uid)"
        case .deleteUser:
            return "/app/users/delete?token=\(token)"
        case .fetchRecommendation(
            let location,
            let radius,
            let numberOfItems
        ):
            return "/app/main/placeInfo" +
            makeQuery(for: [
                "serviceLanguage": "\(language)",
                "pageSize": "\(numberOfItems)",
                "pageNumber": "1",
                "mapX": "\(location.long)",
                "mapY": "\(location.lat)",
                "radius": "\(radius)",
                "token": "\(token)"
            ])
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
        case .postReviewImages(let contentId, let dateString):
            return "/app/placeInfo/review/photo?contentId=\(contentId)&token=\(token)&date=\(dateString)"
        case .fetchSearchLocations(let keyword, pageSize: let pageSize, pageNumber: let pageNumber):
            let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "/app/main/placeInfo/keyword?serviceLanguage=\(language)&keyword=\(encodedKeyword)&pageSize=\(pageSize)&pageNumber=\(pageNumber)&token=\(token)"
        case .postAddToMyTravel:
            return "/app/trip"
        case .myTravel(let planIdx):
            return "/app/trip" +
            makeQuery(for: [
                "token": "\(token)",
                "planIdx": "\(planIdx)"
            ])
        case .fetchMyTravel:
            return "/app/trip" +
            makeQuery(for: [
                "token": "\(token)"
            ])
        case .removeMyTravel(let planIdx):
            return "/app/trip" +
            makeQuery(for: [
               "token": "\(token)",
               "planIdx": "\(planIdx)"
            ])
        case .fetchSavedTravel:
            return "/app/trip/bookmark" +
            makeQuery(for: [
                "token": "\(token)"
            ])
        case .fetchCompletedTravel:
            return "/app/trip/complete" +
            makeQuery(for: [
               "token": "\(token)"
            ])
        case .updateBookMark(
            let contentId,
            contentTypeId: let contentTypeId,
            mapX: let mapX,
            mapY: let mapY,
            placeName: let placeName,
            placeAddr: let placeAddr
        ):
            return "/app/main/placeInfo/bookmark" +
            makeQuery(for: [
                "token": "\(token)",
                "contentId": "\(contentId)",
                "contentTypeId": "\(contentTypeId)",
                "mapX": "\(mapX)",
                "mapY": "\(mapY)",
                "placeName": "\(placeName.addingPercentEncoding)",
                "placeAddr": "\(placeAddr.addingPercentEncoding)"
            ])
        case .fetchLocationDetailImage(let contentId):
            return "/app/placeInfo/images" +
            makeQuery(for: [
                "contentId": "\(contentId)",
                "serviceLanguage": "\(language)"
            ])
        case .fetchReviews(let contentId):
            return "/app/placeInfo/review" +
            makeQuery(for: [
                "token": "\(token)",
                "contentId": "\(contentId)"
            ])
        case .fetchCharacterInfo:
            return "/app/users/myCharacter" +
            makeQuery(for: [
                "token": "\(token)"
            ])
        case .fetchMyInfo:
            return "/app/users/myPage" +
            makeQuery(for: [
                "token": "\(token)"
            ])
        case .fetchMyReviews:
            return "/app/users/myReviews" +
            makeQuery(for: [
                "token": "\(token)"
            ])
        case .postCompleteTrip:
            return "/app/trip/complete"
        case .patchLike:
            return "/app/placeInfo/review/like"
        case .postReport:
            return "/app/placeInfo/review/report"
        case .deleteReview(let reviewIdx):
            return "/app/placeInfo/review" +
            makeQuery(for: [
                "token": "\(token)",
                "reviewIdx": "\(reviewIdx)"
            ])
        case .fetchCategoryPlaces(let location, let category):
            return "/app/main/category" +
            makeQuery(for: [
                "pageSize": "5",
                "pageNumber": "1",
                "mapX": "\(location.long)",
                "mapY": "\(location.lat)",
                "token": "\(token)",
                "category": "\(category.rawValue)",
                "serviceLanguage": "\(language)"
            ])
        }
    }
    public var fullUrl: String {
        return "\(baseURL)" + "\(endPoint)"
    }
    private func makeQuery(for queryParams: [String: String] = [:]) -> String {
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        let queries = "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        return queries
    }
}
