protocol MyMapCollectionViewCellDelegate: AnyObject {
    func didSelectMyLampImage()
}

    
    weak var delegate: MyMapCollectionViewCellDelegate?
    @objc
    private func didTap() {
        print("didTap")
        delegate?.didSelectMyLampImage()
    }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        mapImageView.addGestureRecognizer(gesture)
