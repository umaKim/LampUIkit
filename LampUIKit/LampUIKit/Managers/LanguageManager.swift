//
//  LanguageManager.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/06.
//

import Foundation

enum LanguageType: String {
    case korean = "KorService"
    case enghlish = "EngService"
    case japanese = "JpnService"
}

class LanguageManager {
    static let shared = LanguageManager()
    
    private(set) var languageType: LanguageType = .korean
    
    public func setLanguage(_ type: LanguageType) {
        self.languageType = type
    }
}
