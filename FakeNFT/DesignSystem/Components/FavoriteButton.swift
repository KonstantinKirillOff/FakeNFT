import UIKit

final class FavoriteButton: UIButton {
    var nftID: String?
    
    var isFavorite: Bool = false {
        didSet {
            let imageName = self.isFavorite ? "Heart Filled" : "Heart Empty"
            self.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
