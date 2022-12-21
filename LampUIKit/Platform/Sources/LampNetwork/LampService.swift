//
//  LampService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//
import Alamofire
import Foundation

public protocol Networkable {
    func get<RESPONSE: Decodable>(
        _ request: URLConfigurator,
        _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, AFError>
        ) -> Void
    )
    func post<PARAMETERS: Encodable, RESPONSE: Decodable>(
        _ request: URLConfigurator,
        _ parameter: PARAMETERS,
        _ response: RESPONSE.Type, completion: @escaping (Result<RESPONSE, AFError>) -> Void
    )
    func patch<PARAMETERS: Encodable, RESPONSE: Decodable>(
        _ request: URLConfigurator,
        _ response: RESPONSE.Type,
        parameters: PARAMETERS?,
        completion: @escaping (Result<RESPONSE, AFError>) -> Void
    )
    func delete<RESPONSE: Decodable>(
        _ request: URLConfigurator,
        _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, AFError>) -> Void
    )
    func uploadMultipartForm<RESPONSE: Decodable>(
        _ request: URLConfigurator, _ datum: [Data],
        _ contentId: String, _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, AFError>) -> Void
    )
}

public struct NetworkManager: Networkable {
    public func get<RESPONSE>(
        _ request: URLConfigurator,
        _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void
    ) where RESPONSE: Decodable {
        AF.request(
            request.fullUrl,
            method: .get,
            encoding: JSONEncoding.default
        )
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    public func post<PARAMETERS, RESPONSE>(
        _ request: URLConfigurator,
        _ parameter: PARAMETERS,
        _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void
    ) where PARAMETERS: Encodable, RESPONSE: Decodable {
        AF.request(
            request.fullUrl,
            method: .post,
            parameters: parameter,
            encoder: JSONParameterEncoder(),
            headers: nil
        )
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    public func patch<PARAMETERS, RESPONSE>(
        _ request: URLConfigurator,
        _ response: RESPONSE.Type,
        parameters: PARAMETERS? = Empty.value,
        completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void
    ) where PARAMETERS: Encodable, RESPONSE: Decodable {
        AF.request(
            request.fullUrl,
            method: .patch,
            parameters: parameters,
            encoder: JSONParameterEncoder(),
            headers: nil
        )
            .validate()
            .responseDecodable(of: response.self) { response in
                completion(response.result)
            }
    }
    public func delete<RESPONSE>(
        _ request: URLConfigurator,
        _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void
    ) where RESPONSE: Decodable {
        AF.request(
            request.fullUrl,
            method: .delete
        )
        .validate()
        .responseDecodable(of: response.self) { response in
            completion(response.result)
        }
    }
    public func uploadMultipartForm<RESPONSE>(
        _ request: URLConfigurator,
        _ datum: [Data],
        _ contentId: String,
        _ response: RESPONSE.Type,
        completion: @escaping (Result<RESPONSE, Alamofire.AFError>) -> Void
    ) where RESPONSE: Decodable {
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        AF.upload(
            multipartFormData: { multipartFormData in
            for image in datum {
                multipartFormData.append(
                    image,
                    withName: "dev",
                    fileName: "\(contentId)-\(UUID().uuidString).jpg",
                    mimeType: "image/jpeg"
                )
            }
        }, to: request.fullUrl, headers: headers)
        .responseDecodable(of: response.self) { response in
            completion(response.result)
        }
    }
    public init() {}
}
