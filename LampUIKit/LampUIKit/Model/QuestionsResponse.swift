//
//  QuestionsResponse.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/12.
//

import Foundation

struct QuestionsResponse: Codable {
    let result: [Question]
}

struct Question: Codable {
    let surveyIdx: Int
    let title: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let option4: String?
    let option5: String?
}
