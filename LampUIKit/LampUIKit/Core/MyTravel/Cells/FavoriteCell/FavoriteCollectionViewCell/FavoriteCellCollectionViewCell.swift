
protocol FavoriteCellCollectionViewCellDelegate: AnyObject {
    func favoriteCellCollectionViewCellDidTapDelete(at index: Int)
}

final class FavoriteCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteCellCollectionViewCell"
    
    weak var delegate: FavoriteCellCollectionViewCellDelegate?
    
    private let containerView: UIView = {
        let uv = UIView()
        uv.layer.cornerRadius = 6
        uv.layer.borderColor = UIColor.systemGray.cgColor
        uv.backgroundColor = .greyshWhite
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "경복궁"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        lb.numberOfLines = 1
        return lb
    }()
    
    private lazy var favoriteButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(named: "favorite_saved"), for: .normal)
        return bt
    }()
    
    private lazy var timeLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        lb.text = "09:00~18:30 (입장마감은 17:30)"
        lb.textColor = .midNavy
        return lb
    }()
    
    private lazy var addressLabel: UILabel = {
       let lb = UILabel()
        lb.text = "주소 어쩌구 저쩌구"
        lb.textColor = .midNavy
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    override init(frame: CGRect) {
    private func bind() {
        favoriteButton
            .tapPublisher
            .sink { _ in
                self.isSaveButtonTapped.toggle()
                
                if self.isSaveButtonTapped {
                    self.favoriteButton.setImage(UIImage(named: "favorite_saved"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "favorite_unsaved"), for: .normal)
                    self.delegate?.favoriteCellCollectionViewCellDidTapDelete(at: self.tag)
                }
            }
            .store(in: &cancellables)
    }
        let totalSv = UIStackView(arrangedSubviews: [titleLabel, timeLabel, addressLabel])
        totalSv.axis = .vertical
        totalSv.alignment = .fill
        totalSv.distribution = .fill
        totalSv.spacing = 6
        
        [containerView, totalSv, favoriteButton].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            
            totalSv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalSv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
//    var showDeleButton: Bool? {
//        didSet{
//            deleteButton.isHidden = !(showDeleButton ?? false)
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
