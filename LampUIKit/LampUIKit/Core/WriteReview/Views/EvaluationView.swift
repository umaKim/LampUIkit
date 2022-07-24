import Combine
import UIKit

enum EvaluationViewAction {
    case updateElement(EvaluationModel)
}
final class EvaluationView: BaseWhiteView {
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
    
    private var elements: [EvaluationModel]
    
    init(title: String, elements: [EvaluationModel]) {
        self.titleLabel.text = title
        self.elements = elements
        super.init()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupUI()
    }
    
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
extension EvaluationView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EvaluationCollectionViewCell.identifier,
                                                          for: indexPath) as? EvaluationCollectionViewCell
        else {return UICollectionViewCell() }
        cell.configure(with: elements[indexPath.item])
        return cell
    }
}

extension EvaluationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = elements[indexPath.item].title
        let width = name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold)]).width + 24
        let height: CGFloat = EvaluationCollectionViewCell.preferredHeight
        return CGSize(width: width, height: height)
    }
}
