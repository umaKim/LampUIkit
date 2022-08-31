//
//  MyCharacterViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//
import Combine
import UIKit

enum MyCharacterViewModelNotify {
    case reload
}

class MyCharacterViewModel: BaseViewModel {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<MyCharacterViewModelNotify, Never>()
    
    private let characterImage: [UIImage?] = [
        .init(named: "bear"),
        .init(named: "cat"),
        .init(named: "racoon"),
        .init(named: "dog"),
        .init(named: "rabbit"),
    ]
    
    private(set) var characterData: CharacterData?
    
    override init() {
        super.init()
        
        NetworkService.shared.fetchCharacterInfo {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let info):
                print(info)
                self.characterData = .init(characterName: info.nickName,
                                           level: "\(info.characterLevel)",
                                           imageString: info.characterImageUrl,
                                           averageStat: "\(info.totalExp)",
                                           mileage: "\(info.points)",
                                           gaugeDatum: [
                                            .init(name: "탐구 게이지", rate: "\(info.exploreExp) / \(50)"),
                                            .init(name: "인싸 게이지", rate: "\(info.socialExp) / \(50)"),
                                            .init(name: "여행 게이지", rate: "\(info.travelExp) / \(50)")
                                           ])
                self.notifySubject.send(.reload)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
