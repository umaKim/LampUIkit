//
//  MyPageViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//
import KakaoSDKUser
import FirebaseAuth
import Combine
import Foundation

enum MyPageViewModelNotify {
    case goBackToBeforeLoginPage
}

class MyPageViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MyPageViewModelNotify, Never>()
    
    private(set) var models: [String] = ["로그아웃", "회원탈퇴"]
    
    public func logout() {
        do {
           try Auth.auth().signOut()
            self.notifySubject.send(.goBackToBeforeLoginPage)
        } catch {
            print(error)
    public func deleteAccount() {
        NetworkService.shared.deleteUser { result in
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    
                    switch NetworkService.shared.userAuthType {
                    case .kakao:
                        self.kakaoSignout()
                        
                    case .firebase:
                        Auth.auth().currentUser?.delete(completion: { _ in
                            self.notifySubject.send(.goBackToBeforeLoginPage)
                        })
                        
                    case .none:
                        break
                    }
                   
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    public func deleteAccount() {
        
    }
}
