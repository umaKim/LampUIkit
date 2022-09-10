//
//  BaseXMLService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/17.
//

import Foundation

class BaseXMLService: NSObject {
    internal let baseUrl = "http://api.visitkorea.or.kr/openapi/service/rest/"
    
    enum Key {
        static let encoding = "0IPKAzuqgRL%2BlJLFKeV4YTkgTV%2B90JKXrqf81CWgLhY%2BmtJBbP61uC7JH%2BiiYAlIfP2cFE7bKY1vmI5MGX45Pg%3D%3D"
    }
    
    enum Language {
        case kr, en
    }
    
    func language(_ lang: Language) -> String {
        switch lang {
        case .kr:
            return "KorService"
        case .en:
            return "KorService"
        }
    }
}
