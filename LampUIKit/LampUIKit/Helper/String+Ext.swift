//
//  String+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/04.
//

import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let string = try NSAttributedString(data: data,
                                                options: [
                                                  .documentType:
                                                      NSAttributedString.DocumentType.html,
                                                  .characterEncoding:
                                                      String.Encoding.utf8.rawValue
                                                ],
                                                documentAttributes: nil)
            return string
        } catch {
            return nil
        }
    }
    
    var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    var lightNavyColored: NSAttributedString {
        let att = [NSAttributedString.Key.foregroundColor: UIColor.lightNavy]
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func colored(with color: UIColor) -> NSMutableAttributedString? {
        let attribtuedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: self)
        attribtuedString.addAttribute(.foregroundColor, value: color, range: range)
        return attribtuedString
    }
}

extension String {
    var localized: String {
        
        let selectedLanguage = LanguageManager.shared.localizeLang
        let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        let localizedText = bundle!.localizedString(forKey: self, value: nil, table: nil)
        return localizedText
    }
}
