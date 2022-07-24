import CombineCocoa
import Combine
enum CategoryButtonViewAction {
    case all
    case recommend
    case travel
    case notVisit
}
    private(set) lazy var actionPublisher = actionSubect.eraseToAnyPublisher()
    private let actionSubect = PassthroughSubject<CategoryButtonViewAction, Never>()
        bind()
    private func bind() {
        allButton.tapPublisher.sink { _ in
            self.actionSubect.send(.all)
        }
        .store(in: &cancellables)
        
        recommendOrderButton.tapPublisher.sink { _ in
            self.actionSubect.send(.recommend)
        }
        .store(in: &cancellables)
        
        travelButton.tapPublisher.sink { _ in
            self.actionSubect.send(.travel)
        }
        .store(in: &cancellables)
        
        notVisitButton.tapPublisher.sink { _ in
            self.actionSubect.send(.notVisit)
        }.store(in: &cancellables)
    }
