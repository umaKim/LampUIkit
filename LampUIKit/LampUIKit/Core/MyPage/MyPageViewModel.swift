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

enum MyPageViewModelNotification: Notifiable {
    case goBackToBeforeLoginPage
    
    case myInfo(MyInfo)
    case reload
}

class MyPageViewModel: BaseViewModel<MyPageViewModelNotification> {
    private(set) var myInfo: MyInfo?
    
    private(set) var models: [String] = ["나의 여행 후기", "로그아웃", "회원탈퇴"]
    
    override init() {
        super.init()
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        NetworkManager.shared.fetchMyInfo { result in
            switch result {
            case .success(let info):
                self.myInfo = info
                self.sendNotification(.reload)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func logout() {
        switch NetworkManager.shared.userAuthType {
        case .kakao:
            kakaoSignout()
            
        case .firebase:
            firebaseSignout()
            
        case .none:
            break
        }
    }
    
    public func deleteAccount() {
        NetworkManager.shared.deleteUser {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    
                    switch NetworkManager.shared.userAuthType {
                    case .kakao:
                        self.kakaoSignout()
                        
                    case .firebase:
                        Auth.auth().currentUser?.delete(completion: { _ in
//                            self.notifySubject.send(.goBackToBeforeLoginPage)
                            self.sendNotification(.goBackToBeforeLoginPage)
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
        UserApi.shared.logout {[weak self] (error) in
            guard let self = self else {return}
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
//            self.notifySubject.send(.goBackToBeforeLoginPage)
            self.sendNotification(.goBackToBeforeLoginPage)
        }
    }
    
    private func firebaseSignout() {
        do {
           try Auth.auth().signOut()
//            self.notifySubject.send(.goBackToBeforeLoginPage)
            self.sendNotification(.goBackToBeforeLoginPage)
        } catch {
            print(error)
        }
    }
}
