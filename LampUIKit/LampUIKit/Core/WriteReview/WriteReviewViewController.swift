//
//  WriteReviewViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UIKit

class WriteReviewViewController: BaseViewContronller {

    private let viewModel: WriteReviewViewModel
    
    init(_ vm: WriteReviewViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    private let contentView = WriteReviewView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.actionPublisher.sink { action in
            switch action {
            case .updateSatisfactionModel(let satisfactionRatings):
                self.viewModel.setComfortRating(satisfactionRatings.title)
            
            case .updateAtmosphereModel(let atmosphereRatings):
                self.viewModel.setAtmosphereRating(atmosphereRatings.title)
            
            case .updateSurroundingModel(let surroundingRatings):
                self.viewModel.setSurroundingRating(surroundingRatings.title)
            
            case .updateFoodModel(let foodRatings):
                self.viewModel.setFoodRating(foodRatings.title)
                
            case .updateStarRating(let starRating):
                self.viewModel.setStarRating(starRating)
                
            case .updateComment(let text):
                self.viewModel.setComments(text)
            }
        }
        .store(in: &cancellables)
        
        viewModel.notifyPublisher.sink { noti in
            switch noti {
            case .ableCompleteButton(let isAble):
                self.contentView.ableCompleteButton(isAble)
            }
        }
        .store(in: &cancellables)
    }

}
