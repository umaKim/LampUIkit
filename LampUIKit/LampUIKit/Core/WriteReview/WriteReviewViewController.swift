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
    
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int = 300) {
        if textView.text.count > maxLength {
            textView.deleteBackward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.actionPublisher.sink { action in
            switch action {
            case .updateSatisfactionModel(let satisfactionRatings):
                self.viewModel.setComfortRating(satisfactionRatings)
            
            case .updateAtmosphereModel(let atmosphereRatings):
                self.viewModel.setAtmosphereRating(atmosphereRatings)
            
            case .updateSurroundingModel(let surroundingRatings):
                self.viewModel.setSurroundingRating(surroundingRatings)
            
            case .updateFoodModel(let foodRatings):
                self.viewModel.setFoodRating(foodRatings)
                
            case .updateStarRating(let starRating):
                self.viewModel.setStarRating(starRating)
                
            case .updateComment(let text):
                self.viewModel.setComments(text)
                
            case .addPhoto:
                print("addphoto")
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
                
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
