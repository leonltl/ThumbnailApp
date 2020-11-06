
import UIKit

class EnlargeImageViewController: UIViewController {

    @IBOutlet weak var thumbnailView: ThumbnailView!
    public var _thumbnailInfo:ThumbnailInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let thumbnailInfo = _thumbnailInfo {
            thumbnailView.download(from: thumbnailInfo.imageUrl)
            thumbnailView.thumbnailImage.layer.cornerRadius = 10
            
            /// Switch off the shadow
            thumbnailView.thumbnailImage.layer.shadowColor = UIColor.clear.cgColor
            thumbnailView.thumbnailImage.layer.shadowOffset = CGSize(width: 3, height: 3)
            thumbnailView.thumbnailImage.layer.shadowOpacity = 0
            thumbnailView.thumbnailImage.layer.shadowRadius = 0
        }
        
        /// Lock the orientation for this view controller
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rotationMode = 2
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        thumbnailView.accessibilityIdentifier = "EnlargeThumbnailView"
    }
    
}
