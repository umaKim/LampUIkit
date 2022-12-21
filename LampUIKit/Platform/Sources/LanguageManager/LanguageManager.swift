//
//  LanguageManager.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/06.
//

import Foundation

public enum LanguageType: String {
    case korean     = "KorService"
    case enghlish   = "EngService"
    case japanese   = "JpnService"
}

public class LanguageManager {
    public static let shared = LanguageManager()
    public var languageType: LanguageType = .korean
    public var localizeLang: String = ""
    public func setLanguage(_ type: LanguageType) {
        self.languageType = type
        switch type {
        case .korean:
            self.localizeLang = "ko"
        case .japanese:
            self.localizeLang = "ja"
        case .enghlish:
            self.localizeLang = "en"
        }
    }
}
