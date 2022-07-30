protocol MyTravelCellHeaderCellDelegate:AnyObject {
    func myTravelCellHeaderCellDidSelectEdit()
    func myTravelCellHeaderCellDidSelectComplete()
}
final class MyTravelCellHeaderCell: UICollectionReusableView {
    static let identifier = "MyTravelCellHeaderCell"
    
    weak var delegate: MyTravelCellHeaderCellDelegate?
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
                    self.delegate?.myTravelCellHeaderCellDidSelectEdit()
                    self.delegate?.myTravelCellHeaderCellDidSelectComplete()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
