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
            let font = UIFont.systemFont(ofSize: 72)
            let attributes = [NSAttributedString.Key.font: font]
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
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
