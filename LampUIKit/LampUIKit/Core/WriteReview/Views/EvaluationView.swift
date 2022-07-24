import Combine
import UIKit

enum EvaluationViewAction {
    case updateElement(EvaluationModel)
}
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<EvaluationViewAction, Never>()
    
    private let titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "만족도"
        lb.textAlignment = .left
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    
    private let collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(EvaluationCollectionViewCell.self, forCellWithReuseIdentifier: EvaluationCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
        setupUI()
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, collectionView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
