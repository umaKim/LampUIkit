//
//  URLRequestable.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/09.
//
import Alamofire
import Foundation

protocol URLRequestable {
    var baseURL: String { get }
    var endPoint: String { get }
    var fullUrl: String { get }
}
