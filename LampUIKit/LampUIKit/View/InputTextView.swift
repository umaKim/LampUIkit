//
//  InputTextView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/18.
//

import UIKit

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
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        ])
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    @objc
    private func textFieldDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
