//
//  MyPageTableViewHeaderView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import UIKit

class MyPageTableViewHeaderView: UIView {
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.font = .robotoBold(20)
        label.numberOfLines = 2
        label.textColor = .darkNavy
        return label
    }()
    private lazy var visitedTravelLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium(14)
        label.textColor = .opaqueGrey
        return label
    }()
    private lazy var writtenLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium(14)
        label.textColor = .opaqueGrey
        return label
    }()
    init(
        _ myInfo: MyInfo
    ) {
        super.init(frame: .zero)
        nameLabel.text = myInfo.nickName + " 님\n".localized + "안녕하세요".localized
        let visitedTravelLabelAttStrings = [
            "내가 갔다 온 여행".localized.attributed,
            "\(myInfo.numOfPlan)".lightNavyColored,
            "개".localized.attributed].compactMap({$0})
        visitedTravelLabel.attributedText = visitedTravelLabelAttStrings.joined(with: " ")
        let writtenLabelAttStrings = [
            "작성한 여행 후기".localized.attributed,
            "\(myInfo.numOfReview)".lightNavyColored,
            "개".localized.attributed
        ].compactMap({$0})
        writtenLabel.attributedText = writtenLabelAttStrings.joined(with: " ")
        setupUI()
    }
    private func setupUI() {
        backgroundColor = .greyshWhite
        let leftSv = UIStackView(arrangedSubviews: [nameLabel])
        leftSv.axis = .vertical
        leftSv.alignment = .fill
        leftSv.distribution = .fillProportionally
        leftSv.spacing = 8
        let rightSv = UIStackView(arrangedSubviews: [visitedTravelLabel, writtenLabel])
        rightSv.axis = .vertical
        rightSv.alignment = .trailing
        rightSv.distribution = .fillProportionally
        rightSv.spacing = 8
        [leftSv, rightSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        NSLayoutConstraint.activate([
            leftSv.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rightSv.bottomAnchor.constraint(equalTo: leftSv.bottomAnchor),
            rightSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
