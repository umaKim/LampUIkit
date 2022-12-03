//
//  MyCharacterViewModel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/22.
//
import Combine
import UIKit

enum MyCharacterViewModelNotification: Notifiable {
    case reload
}

class MyCharacterViewModel: BaseViewModel<MyCharacterViewModelNotification> {
    private let characterImage: [UIImage?] = [
        .init(named: "bear"),
        .init(named: "cat"),
        .init(named: "racoon"),
        .init(named: "dog"),
        .init(named: "rabbit")
    ]
    private(set) var characterData: CharacterData?
    private let network: Networkable
    init(
        _ network: Networkable = NetworkManager()
    ) {
        self.network = network
        super.init()
        network.get(
            .fetchCharacterInfo,
            MyCharacter.self
        ) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let info):
                self.characterData = .init(
                    characterName: info.nickName,
                    level: "\(info.characterLevel)",
                    imageString: info.characterImageUrl,
                    averageStat: "\(info.avgExp)",
                    mileage: "\(info.points)",
                    gaugeDatum: [
                        .init(name: "탐구 게이지", rate: info.exploreExp),
                        .init(name: "인싸 게이지", rate: info.socialExp),
                        .init(name: "여행 게이지", rate: info.travelExp)
                    ])
                self.sendNotification(.reload)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
