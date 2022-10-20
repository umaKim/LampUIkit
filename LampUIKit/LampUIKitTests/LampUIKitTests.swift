//
//  LampUIKitTests.swift
//  LampUIKitTests
//
//  Created by 김윤석 on 2022/07/13.
//

@testable import LampUIKit
import Quick
import Nimble
import Combine

class LoginViewModelTest: QuickSpec {
    private var cancellables: Set<AnyCancellable> = []

    override func spec() {

        var auth: MockAuthManager!
        var network: MockNetworkManager!
        var viewModel: LoginViewModel!
        
        var isPresentCreateNickName: Bool = false
        var isPresentInitialSetpage: Bool = false

        func prepare() {
            auth = MockAuthManager()
            network = MockNetworkManager()
            viewModel = LoginViewModel(auth, network)
        }

        describe("checkUserExist") {
            prepare()
            viewModel.notifyPublisher.sink { noti in
                switch noti {

                //case1: success with nickname
                case .changeRootViewController(let uid):
                    expect(uid).to(equal("exist"))

                //case2: success without nickname
                case .presentCreateNickName:
                    expect(isPresentCreateNickName).to(beTrue())

                //case3: fail
                case .presentInitialSetpage:
                    expect(isPresentInitialSetpage).to(beTrue())
                }
            }
            .store(in: &cancellables)
            
            //case1: success with nickname
            network.userExistCheckResponse = .init(isSuccess: true, nicknameExist: true, userIdx: 0)
            viewModel.checkUserExist("exist")

            //case2: success without nickname
            network.userExistCheckResponse = .init(isSuccess: true, nicknameExist: nil, userIdx: 0)
            viewModel.checkUserExist("exist")
            isPresentCreateNickName = true
            
            //case3: fail
            network.userExistCheckResponse = .init(isSuccess: false, nicknameExist: nil, userIdx: nil)
            viewModel.checkUserExist("exist")
            isPresentInitialSetpage = true
        }

    }
}
