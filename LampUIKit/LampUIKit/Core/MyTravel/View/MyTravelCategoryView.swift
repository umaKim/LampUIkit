import Combine
enum MenuBarButtonAction {
    case didTapMyTravel
    case didTapFavoritePlace
    case didTapCompletedTravel
}
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MenuBarButtonAction, Never>()
    private var cancellable: Set<AnyCancellable>
    
    private lazy var myTravelButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("나의 여행지", for: .normal)
        bt.setTitleColor(UIColor.lightNavy, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return bt
    }()
    
    private lazy var favoritePlaceButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("찜한 장소", for: .normal)
        bt.setTitleColor(UIColor.lightNavy, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return bt
    }()
    
    private lazy var completedTravelButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("완료된 여행", for: .normal)
        bt.setTitleColor(UIColor.lightNavy, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return bt
    }()
    
    private lazy var selectionBarView: UIView = {
        let uv = UIView(frame: .init(x: 0, y: 56, width: UIScreen.main.width / 3, height: 3))
        uv.backgroundColor = .lightNavy
        return uv
    }()
    
    private let separatorView = DividerView()
        self.cancellable = .init()
        let sv = UIStackView(arrangedSubviews: [myTravelButton, favoritePlaceButton, completedTravelButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        
        [sv, separatorView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        addSubview(selectionBarView)
    
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            
            selectionBarView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
            
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    private func setAlpha(for button: UIButton) {
        self.myTravelButton.alpha = 0.5
        self.myTravelButton.setTitleColor(.gray, for: .normal)
        self.favoritePlaceButton.alpha = 0.5
        self.favoritePlaceButton.setTitleColor(.gray, for: .normal)
        self.completedTravelButton.alpha = 0.5
        self.completedTravelButton.setTitleColor(.gray, for: .normal)
        
        button.alpha = 1.0
        button.setTitleColor(.midNavy, for: .normal)
    }
    private func animateIndicator(to index: Int) {
        
        var button: UIButton
        
        switch index {
        case 0:
            button = myTravelButton
        case 1:
            button = favoritePlaceButton
        case 2:
            button = completedTravelButton
        default:
            button = myTravelButton
        }
        
        setAlpha(for: button)
        
    }
