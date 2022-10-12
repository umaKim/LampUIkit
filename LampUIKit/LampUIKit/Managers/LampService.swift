//
//  LampService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//
import Alamofire
import Foundation

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
}
