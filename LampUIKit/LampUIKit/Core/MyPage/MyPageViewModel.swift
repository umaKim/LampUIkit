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
    
    case myInfo(MyInfo)
    case reload
}

class MyPageViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MyPageViewModelNotify, Never>()
    
    private(set) var myInfo: MyInfo?
    
    private(set) var models: [String] = ["나의 여행 후기","로그아웃", "회원탈퇴"]
    
    override init() {
        super.init()
        NetworkService.shared.fetchMyInfo { result in
            switch result {
            case .success(let info):
                self.myInfo = info
                self.notifySubject.send(.reload)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchUserInfo() {
        
    }
    
    public func logout() {
        switch NetworkService.shared.userAuthType {
        case .kakao:
            kakaoSignout()
            
        case .firebase:
            firebaseSignout()
            
        case .none:
            break
        }
    }
    
    public func deleteAccount() {
        NetworkService.shared.deleteUser {[unowned self] result in
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
    }
    
    private func kakaoSignout() {
        UserApi.shared.logout {[unowned self] (error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
            self.notifySubject.send(.goBackToBeforeLoginPage)
        }
    }
    
    private func firebaseSignout() {
        do {
           try Auth.auth().signOut()
            self.notifySubject.send(.goBackToBeforeLoginPage)
        } catch {
            print(error)
        }
    }
}
