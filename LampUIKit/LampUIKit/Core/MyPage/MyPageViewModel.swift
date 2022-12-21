//
//  MyPageViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//
import AuthManager
import LampNetwork
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
    private(set) var models: [String] = ["나의 여행 후기", "언어선택", "로그아웃", "회원탈퇴"]
    private(set) var auth: Autheable
    private let network: Networkable
    init(
        _ auth: Autheable = AuthManager.shared,
        _ network: Networkable = NetworkManager()
    ) {
        self.auth = auth
        self.network = network
        super.init()
        fetchUserInfo()
    }
    private func fetchUserInfo() {
        network.get(.fetchMyInfo, MyInfo.self) {[weak self] result in
            guard let self = self else {return}
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
        switch auth.userAuthType {
        case .kakao:
            kakaoSignout()
        case .firebase:
            firebaseSignout()
        case .google, .apple:
            firebaseSignout()
        case .none:
            break
        }
    }
    public func deleteAccount() {
        network.patch(.deleteUser, Response.self, parameters: Empty.value) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                if response.isSuccess ?? false {
                    switch self.auth.userAuthType {
                    case .kakao:
                        self.kakaoSignout()
                    case .firebase:
                        Auth.auth().currentUser?.delete(completion: {[weak self] _ in
                            guard let self = self else {return }
                            self.sendNotification(.goBackToBeforeLoginPage)
                        })
                    case .google, .apple:
                        Auth.auth().currentUser?.delete(completion: {[weak self] _ in
                            guard let self = self else {return }
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
            } else {
                print("logout() success.")
            }
            self.sendNotification(.goBackToBeforeLoginPage)
        }
    }
    private func firebaseSignout() {
        do {
            try Auth.auth().signOut()
            self.sendNotification(.goBackToBeforeLoginPage)
        } catch {
            print(error)
        }
    }
}
