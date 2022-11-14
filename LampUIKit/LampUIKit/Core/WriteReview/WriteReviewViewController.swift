//
//  WriteReviewViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UmaBasicAlertKit
import UIKit

class WriteReviewViewController: BaseViewController<WriteReviewView, WriteReviewViewModel>, Alertable {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItems = [contentView.backButton]
        hideKeyboardWhenTappedAround()
        contentView.textContextView.delegate = self
        contentView.configure(viewModel.location)
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .medium)
                switch action {
                case .back:
                    self.navigationController?.popViewController(animated: true)
                    
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
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.delegate = self
                    vc.allowsEditing = true
                    self.present(vc, animated: true)
                    
                case .removeImage(let index):
                    self.viewModel.removeImage(at: index)
                    
                case .complete:
                    self.viewModel.completeButton()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .ableCompleteButton(let isAble):
                    self.contentView.ableCompleteButton(isAble)
                    
                case .dismiss:
                    self.navigationController?.popViewController(animated: true)
                    
                case .showMessage(let message):
                    self.showDefaultAlert(title: message)
                    
                case .startLoading:
                    self.showLoadingView()
                    
                case .endLoading:
                    self.dismissLoadingView()
                    
                case .numberOfImages(let count):
                    self.contentView.setImageCounter(count)
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkMaxLength(_ textView: UITextView, maxLength: Int = 300) {
        if textView.text.count > maxLength {
            textView.deleteBackward()
        }
    }
}

//MARK: - UITextViewDelegate
extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        contentView.setCharacterCounter(count)
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension WriteReviewViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            if viewModel.images.count < 3 {
                contentView.setImage(with: image)
                viewModel.addImage(image)
            } else {
                self.showDefaultAlert(title: "사진은 3개로 제한됩니다")
            }
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
