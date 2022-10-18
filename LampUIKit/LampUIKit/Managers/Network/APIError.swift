//
//  APIError.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//

import Foundation

enum APIError: Error, Equatable {
  case defaultError(String, Int)
  case invalidRequest
  case invalidResponse
  case invalidJson(String)
  case unknownError(Int)
  case validationError(String)
  
  var localizedDescription: String {
    switch self {
    case let .defaultError(errorMessage, errorCode):
      return "error \(errorCode)\n\(errorMessage)"
    case .invalidRequest:
      return "Could not create proper request"
    case let .invalidJson(errorMessage):
      return "Could not decode: \(errorMessage)"
    case .invalidResponse:
      return "Could not fetch response"
    case let .unknownError(errorCode):
      return "Could not handle errorCode: \(errorCode)"
    case let .validationError(reason):
      return "Response Failed due to: \(reason)"
    }
  }
}
