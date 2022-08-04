final class FavoriteCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteCellCollectionViewCell"
    
    override init(frame: CGRect) {
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
