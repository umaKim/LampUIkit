
protocol PopularLampSpotCollectionViewCellDelegate:AnyObject {
    func popularLampSpotCollectionViewCellDidTap()
}

    
    weak var delegate: PopularLampSpotCollectionViewCellDelegate?
    @objc
    private func tapHandler() {
        delegate?.popularLampSpotCollectionViewCellDidTap()
    }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        mapImageView.addGestureRecognizer(tap)
