import Combine
enum EvaluationViewAction {
    case updateElement(EvaluationModel)
}
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<EvaluationViewAction, Never>()
