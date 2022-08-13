protocol FavoriteCellHeaderCellDelegate:AnyObject {
    func favoriteCellHeaderCellDidSelectEdit()
    func favoriteCellHeaderCellDidSelectComplete()
}
    weak var delegate: FavoriteCellHeaderCellDelegate?
