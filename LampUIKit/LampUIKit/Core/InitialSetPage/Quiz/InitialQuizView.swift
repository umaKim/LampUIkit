enum InitialQuizViewAction {
    case button1
    case button2
    case button3
    case button4
    case button5
    case next
}
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<InitialQuizViewAction, Never>()
        bind()
    private func bind() {
        quizView
            .actionPublisher
            .sink { action in
                switch action {
                case .button1:
                    self.actionSubject.send(.button1)
                    
                case .button2:
                    self.actionSubject.send(.button2)
                    
                case .button3:
                    self.actionSubject.send(.button3)
                    
                case .button4:
                    self.actionSubject.send(.button4)
                    
                case .button5:
                    self.actionSubject.send(.button5)
                    
                case .next:
                    self.actionSubject.send(.next)
                }
            }
            .store(in: &cancellables)
        
        resultView
            .actionPublisher
            .sink { action in
                switch action {
                case .next:
                    self.actionSubject.send(.next)
                }
            }
            .store(in: &cancellables)
    }
    public func setQuizData(_ data: Question) {
        quizView.setQuizData(data)
    }
    
    public func setCharacterData(_ data: CharacterData) {
        quizView.isHidden = true
        resultView.isHidden = false
        
        resultView.setupCharacter(data)
    }
