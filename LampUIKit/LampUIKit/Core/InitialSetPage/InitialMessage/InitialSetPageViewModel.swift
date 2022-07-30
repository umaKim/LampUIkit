//
//  InitialSetPageViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/30.
//

import Foundation

// FLOW
// (c) Social LogIn <uid를 서버에 보냄> -> (s) response <이미 회원이다 아니다> -> (c) 회원이면 바로 메인 페이지, 회원이 아니라면 Initial Setting page
// (c) Initial Setting Page에서 퀴즈를 시작 -> 하나의 question 끝날때마다 (s)에서 받아야함

class InitialSetPageViewModel {
    
    private(set) lazy var beginningMessage: [String] = [
        " 램프에 오신 것을 환영합니다! ",
        "지금부터 당신에게 맞는\n램프 캐릭터 배정을 시작합니다 ",
        "램프의 캐릭터는 당신과\n여행 할수록 함께 성장합니다"
    ]
    
    
}
