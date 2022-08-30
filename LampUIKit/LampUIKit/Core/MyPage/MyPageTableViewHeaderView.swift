//
//  MyPageTableViewHeaderView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import UIKit

class MyPageTableViewHeaderView: UIView {
    private lazy var nameLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(20)
        lb.numberOfLines = 2
        lb.textColor = .darkNavy
        return lb
    }()
    
//    private lazy var emailLabel: UILabel = {
//        let lb = UILabel()
//        lb.font = .robotoMedium(13)
//        lb.textColor = .opaqueGrey
//        return lb
//    }()
    
    private lazy var visitedTravelLabel: UILabel = {
        let lb = UILabel()
        lb.font = .robotoMedium(14)
        lb.textColor = .opaqueGrey
        return lb
    }()
    
    private lazy var writtenLabel: UILabel = {
        let lb = UILabel()
        lb.font = .robotoMedium(14)
        lb.textColor = .opaqueGrey
        return lb
    }()
    
    init(_ myInfo: MyInfo) {
        super.init(frame: .zero)
        
        nameLabel.text = myInfo.nickName + " 님 \n안녕하세요"
//        emailLabel.text = email
        
        visitedTravelLabel.text = "내가 갔다온 여행 \(myInfo.numOfPlan)개"
        writtenLabel.text = "작성한 여행 후기 \(myInfo.numOfReview)개"
        
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
        rightSv.alignment = .fill
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
            rightSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
