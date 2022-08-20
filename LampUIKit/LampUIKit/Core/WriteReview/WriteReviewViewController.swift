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

        hideKeyboardWhenTappedAround()
        
        contentView.textContextView.delegate = self
        
        contentView.configure(viewModel.location)
        
        contentView
            .actionPublisher
            .sink { action in
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
                
            case .removeImage(let index):
                self.viewModel.removeImage(at: index)
                
            case .complete:
                self.viewModel.completeButton()
            }
        }
        .store(in: &cancellables)
        
        viewModel.notifyPublisher.sink { noti in
            switch noti {
            case .ableCompleteButton(let isAble):
                self.contentView.ableCompleteButton(isAble)
                
            case .dismiss:
                self.dismiss(animated: true)
                
            case .showMessage(let message):
                self.presentUmaDefaultAlert(title: message)
                
            case .startLoading:
                self.showLoadingView()
                
            case .endLoading:
                self.dismissLoadingView()
                
            }
        }
        .store(in: &cancellables)
    }

class InputTextView: UITextView {
    var placeholderText: String? {
        didSet {
            placeholderLabel.text  = placeholderText
        }
    }
    
    private let placeholderLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        return lb
    }()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        textColor = .black
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc
    private func textFieldDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        contentView.setCharacterCounter(count)
    }
}

extension WriteReviewViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            contentView.setImage(with: image)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
