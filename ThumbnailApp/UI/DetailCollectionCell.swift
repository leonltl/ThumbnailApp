
import UIKit

class DetailCollectionCell: UICollectionViewCell {
    @IBOutlet weak var viewWebViewWrapper: VideoView!
    @IBOutlet weak var btnLike: BounceButton!
    @IBOutlet weak var btnDisLike: BounceButton!
    @IBOutlet weak var viewWrapperLikes: UIView!
    @IBOutlet weak var viewWrapperDisLikes: UIView!
    @IBOutlet weak var viewWrapperCount: UIView!
    @IBOutlet weak var lblLikeCounts: UILabel!
}
