//
//  File.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//
import Alamofire
import Combine
import Foundation

protocol APIRequestable {
  var session: URLSession { get set }
  
  func request<T>(request: URLRequest, response: T.Type) -> AnyPublisher<T, APIError> where T: Decodable
  func createRequest(from requestData: URLRequestable) -> URLRequest?
  func handleError(from response: Int) -> APIError
}

extension APIRequestable {
  func request<T>(request: URLRequest, response: T.Type) -> AnyPublisher<T, APIError> where T: Decodable {
    
    return session.dataTaskPublisher(for: request)
      .tryMap { response in
        guard let httpResponse = response.response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
          throw handleError(from: httpResponse.statusCode)
        }
        
        return response.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError({ error in
        APIError.invalidJson(String(describing: error))
      })
      .eraseToAnyPublisher()
  }
  
  func createRequest(from requestData: URLRequestable) -> URLRequest? {
    let urlString: String = "\(requestData.baseURL)/\(requestData.endPoint)"
    guard let url: URL = URL(string: urlString) else { return nil }
    
    var request = URLRequest(url: url)
    request.httpBody = requestData.httpBody
    request.httpMethod = requestData.method.rawValue
    
    if let headers = requestData.httpHeaders {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    return request
  }
}
