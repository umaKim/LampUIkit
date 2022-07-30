final class MyTravelCellHeaderCell: UICollectionReusableView {
    static let identifier = "MyTravelCellHeaderCell"
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
