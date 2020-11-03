
import UIKit

extension DetailsCollectionViewController {
    func playVideo(urlAddress: String) {
        _urlAddress = urlAddress
        self.collectionView.reloadData();
    }
}

// MARK: Actions and events
extension DetailsCollectionViewController {
    @objc func onBtnActionLikeOrDislike(sender : BounceButton){
        
        if sender.tag == 1 {
            sender.setImage(UIImage(named: "heart_filled"), for: UIControl.State.normal)
            
        }
        else {
            sender.setImage(UIImage(named: "cross_filled"), for: UIControl.State.normal)
        }
        
        sender.likeBounce(0.6)
        sender.animate()
        
        guard let view = sender.superview else {
            return
        }
        
        view.layer.borderColor = UIColor.systemRed.cgColor
        
        guard let cell = view.superview?.superview as? DetailCollectionCell else {
            return
        }
        
        if sender.tag == 1 {
            cell.btnDisLike.isUserInteractionEnabled = false
            totalLikesCount+=1
            cell.lblLikeCounts.text = String(totalLikesCount)
        }
        else {
            cell.btnLike.isUserInteractionEnabled = false
        }   
    }
    
}

class DetailsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var _urlAddress: String = ""
    var totalLikesCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.collectionView.delegate = self

        // Do any additional setup after loading the view.
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
            
        }
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
            ///landscape orientation
            
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! DetailCollectionCell
    
        // Configure the cell
        if !_urlAddress.isEmpty {
            cell.btnLike.tag = 1
            
            cell.viewWebViewWrapper.showVideo(urlAddress: self._urlAddress)
            cell.viewWrapperCount.isHidden = true
            cell.viewWrapperDisLikes.isHidden = true
            cell.viewWrapperLikes.isHidden = true
            cell.btnLike.addTarget(self, action: #selector(self.onBtnActionLikeOrDislike), for: .touchUpInside)
            cell.viewWrapperLikes.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            cell.viewWrapperLikes.layer.masksToBounds = false
            cell.viewWrapperLikes.layer.cornerRadius = cell.viewWrapperLikes.frame.width / 2
            cell.viewWrapperLikes.layer.borderColor = UIColor.systemOrange.cgColor
            cell.viewWrapperLikes.layer.borderWidth = 2.0
            
            cell.btnDisLike.tag = 2
            cell.btnDisLike.addTarget(self, action: #selector(self.onBtnActionLikeOrDislike), for: .touchUpInside)
            cell.viewWrapperDisLikes.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            cell.viewWrapperDisLikes.layer.masksToBounds = false
            cell.viewWrapperDisLikes.layer.cornerRadius = cell.viewWrapperDisLikes.frame.width / 2
            cell.viewWrapperDisLikes.layer.borderColor = UIColor.systemOrange.cgColor
            cell.viewWrapperDisLikes.layer.borderWidth = 2.0
            
            cell.viewWrapperCount.layer.borderColor = UIColor.systemOrange.cgColor
            cell.viewWrapperCount.layer.borderWidth = 1.0
            cell.lblLikeCounts.textColor = UIColor.systemOrange
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
                cell.viewWrapperCount.isHidden = false
                cell.viewWrapperDisLikes.isHidden = false
                cell.viewWrapperLikes.isHidden = false
            }
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if #available(iOS 11.0, *) {
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        } else {
            return CGSize(width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        }
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
