import Combine
enum MenuBarButtonAction {
    case didTapMyTravel
    case didTapFavoritePlace
    case didTapCompletedTravel
}
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MenuBarButtonAction, Never>()
    private var cancellable: Set<AnyCancellable>
        self.cancellable = .init()
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
