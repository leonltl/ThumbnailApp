
import UIKit

// MARK: - Public methods for the main controller to call
extension ImagesCollectionViewController {
    public func loadThumbnailList(thumbnailData:[ThumbnailInfo]) {
        _thumbnailInfoData = thumbnailData
        self.collectionView.reloadData()
    }
    
    public func clearThumbnailList() {
        _thumbnailInfoData = [ThumbnailInfo]()
        _hasNoThumbnailToLoad = false
        self.collectionView.reloadData()
    }
    
    public func loadNoThumbnail() {
        _thumbnailInfoData = [ThumbnailInfo]()
        _hasNoThumbnailToLoad = true
        self.collectionView.reloadData()
    }
}

// MARK: Event Actions
internal extension ImagesCollectionViewController {
    @objc
    func onPullToRefresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            NotificationCenter.default.post(name: Notification.Name("TriggerLoadPictures"), object: nil, userInfo: nil)
        }
    }
}

class ImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /// non ui variables
    private var _thumbnailInfoData:[ThumbnailInfo]? = nil
    private var _hasNoThumbnailToLoad:Bool = false
    private var _cellHeight:CGFloat = 275.0
    private var detailController:DetailViewController?
    
    /// ui variables
    private var refreshControl:UIRefreshControl!
     
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(onPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+
        self.collectionView!.addSubview(refreshControl)
    }
    
    // MARK: Orientation methods
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let previousTraitCollection = previousTraitCollection, traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
            traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass else {
                return
        }

        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            ///both landscape and portraint orientation
        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            ///portraint orientation
            _cellHeight = 275.0
        }
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
            ///landscape orientation
            _cellHeight = 325.0
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionView methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (_hasNoThumbnailToLoad) {
            return 1
        }
        
        guard let _ = _thumbnailInfoData else {
            return 0
        }
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (_hasNoThumbnailToLoad) {
            return 1
        }
        
        guard let imagesProperties = _thumbnailInfoData else {
            return 0
        }
        
        return imagesProperties.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (!_hasNoThumbnailToLoad) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! ThumbnailCollectionCell
            let imageProperty = _thumbnailInfoData![indexPath.row]
            cell.thumbnailWrapper.download(from: imageProperty.imageUrl)
            cell.lblCaption.text = imageProperty.caption
            cell.lblCaption.textColor = UIColor.orange
            return cell
        }
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "errorCell", for: indexPath) as! ErrorCollectionCell
        cell.lblError.text = "Problem loading image..."
        cell.lblError.textColor = UIColor.orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if #available(iOS 11.0, *) {
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: _cellHeight)
        } else {
            return CGSize(width: view.frame.width, height: _cellHeight)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (!_hasNoThumbnailToLoad) {
            let cell = collectionView.cellForItem(at: indexPath) as! ThumbnailCollectionCell
            self.performSegue(withIdentifier: "showInfoSegue", sender: cell.lblCaption.text)
        }
    }
  
    
    // MARK: - Segue navigation function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfoSegue") {
            let embedVC = segue.destination as! DetailViewController
            detailController = embedVC
            //print(sender)
            detailController?.caption = sender as? String ?? ""
        }
    }
    

}