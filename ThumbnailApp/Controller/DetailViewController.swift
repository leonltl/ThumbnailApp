
import UIKit
import WebKit

// MARK: Logic Method
internal extension DetailViewController {
    
    /// Method to find the correct youtube video
    /// - Parameters:
    ///   - caption: the caption of the video
    /// - Returns
    ///    The video youtube url address
    func findYoutubeVideo(caption: String) -> String {
        var urlAddress:String = ""
        switch (caption) {
            case "Lonely Railroad":
                urlAddress = "https://youtu.be/CUlJzfQ-Blc"
                break
            case "Autumn Path":
                urlAddress = "https://youtu.be/kC4KdE4j-HY"
                break
            case "Cloudy Hill":
                urlAddress = "https://youtu.be/ivjZWCU9pKA"
                break
            case "Wind Surf":
                urlAddress = "https://youtu.be/8bYtDBZkrpM"
                break
            case "Sidewalk Cafe":
                urlAddress = "https://youtu.be/wG_FcMwoU6M"
                break
            case "Green Forest":
                urlAddress = "https://youtu.be/BjaTMx8ZWK8"
                break
            case "Sunset Ray":
                urlAddress = "https://youtu.be/SJJFKN3HjwU"
                break
            case "Elephant Family":
                urlAddress = "https://youtu.be/gsqlpcVEsqc"
                break
            case "Snowy Mountain":
                urlAddress = "https://youtu.be/k4j3GSrkTbE"
                break
            case "Red House":
                urlAddress = "https://youtu.be/q5z-pl2GxC0"
                break
            default:
                break
        }
        
        return urlAddress
    }
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    /// ux variables
    @IBOutlet weak var tblCommentsList: UITableView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var viewWebViewWrapper: VideoView!
    @IBOutlet weak var btnLike: BounceButton!
    @IBOutlet weak var btnDisLike: BounceButton!
    @IBOutlet weak var viewWrapperLikes: UIView!
    @IBOutlet weak var viewWrapperDisLikes: UIView!
    @IBOutlet weak var viewWrapperCount: UIView!
    @IBOutlet weak var lblLikeCounts: UILabel!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtWriteComment: UITextField!
    
    /// non ux variables
    public var _thumbnailInfo:ThumbnailInfo?
    internal var _cellHeight: CGFloat = 80

    // MARK : Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlAddress = self.findYoutubeVideo(caption: _thumbnailInfo?.caption ?? "")
        if !urlAddress.isEmpty {
            
            /// Set accessiblity identifier
            viewWebViewWrapper.accessibilityIdentifier = "viewWebViewWrapper"
            
            /// Set caption label properties
            lblCaption.text = _thumbnailInfo?.caption
            lblCaption.textColor = UIColor.systemOrange
            
            lblLikeCounts.accessibilityIdentifier = "lblLikeCounts"
            viewWrapperCount.isHidden = true
            
            /// Set Like button properties
            btnLike.tag = 11
            btnLike.isUserInteractionEnabled = true
            btnLike.accessibilityIdentifier = "btnLike"
            viewWrapperLikes.isHidden = true
            viewWrapperLikes.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            viewWrapperLikes.layer.masksToBounds = false
            viewWrapperLikes.layer.cornerRadius = viewWrapperLikes.frame.width / 2
            viewWrapperLikes.layer.borderColor = UIColor.systemOrange.cgColor
            viewWrapperLikes.layer.borderWidth = 2.0
            
            /// Set Dislike button properties
            btnDisLike.tag = 12
            btnDisLike.isUserInteractionEnabled = true
            btnDisLike.accessibilityIdentifier = "btnDisLike"
            viewWrapperDisLikes.isHidden = true
            viewWrapperDisLikes.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            viewWrapperDisLikes.layer.masksToBounds = false
            viewWrapperDisLikes.layer.cornerRadius = viewWrapperDisLikes.frame.width / 2
            viewWrapperDisLikes.layer.borderColor = UIColor.systemOrange.cgColor
            viewWrapperDisLikes.layer.borderWidth = 2.0
            lblLikeCounts.textColor = UIColor.white
            
            /// Set comment  text field  properties
            txtWriteComment.isHidden = true
            txtWriteComment.autocorrectionType = .no
            txtWriteComment.delegate = self
            txtWriteComment.accessibilityIdentifier = "txtWriteComment"

            /// Set comment  list  properties
            tblCommentsList.tableFooterView = UIView()
            tblCommentsList.separatorStyle = .none
            tblCommentsList.isHidden = true
            tblCommentsList.accessibilityIdentifier = "tblCommentsList"
            
            if let thumbnailInfo = _thumbnailInfo {
                lblCaption.text = thumbnailInfo.caption
                lblLikeCounts.text = String(thumbnailInfo.likesCount)
            }
            
            viewWebViewWrapper.showVideo(urlAddress: urlAddress)
            
            /// Show the ux after a slight delay
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
                self.viewWrapperCount.isHidden = false
                self.viewWrapperDisLikes.isHidden = false
                self.viewWrapperLikes.isHidden = false
                self.txtWriteComment.isHidden = false
                self.tblCommentsList.isHidden = false
            }
            
            /// Gesture notification
            let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tapGesture)
            
            /// Keyboard notification
            NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            /// Video full screen notification
            NotificationCenter.default.addObserver(self, selector: #selector(onVideoDidEnterFullscreen), name: UIWindow.didBecomeVisibleNotification, object: view.window)
            NotificationCenter.default.addObserver(self, selector: #selector(onVideoDidLeaveFullscreen), name: UIWindow.didBecomeHiddenNotification, object: view.window)
        }
        else {
            viewWebViewWrapper.showError()
            lblCaption.text = "No video found..."
            
            viewWrapperCount.isHidden = true
            viewWrapperDisLikes.isHidden = true
            viewWrapperLikes.isHidden = true
            tblCommentsList.isHidden = true
            txtWriteComment.isHidden = true
        }
            
        /// Lock the orientation for this view controller
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rotationMode = 1
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
    }
    
    // MARK: Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let thumbnailInfo = _thumbnailInfo {
            return thumbnailInfo.comments.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableCell
        cell.lblComment.clipsToBounds = true
        cell.lblComment.layer.cornerRadius = 10.0
        cell.lblComment.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.5)
        cell.lblComment.numberOfLines = 0
        if let thumbnailInfo = _thumbnailInfo {
            let comment = thumbnailInfo.comments[indexPath.row]
            cell.lblComment.text = comment
            cell.lblComment.sizeToFit()
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onBtnDelete), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return _cellHeight
    }
    
    // MARK: Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        if (textField.text!.isEmpty) {
            return false
        }
        
        if let thumbnailInfo = _thumbnailInfo {
            thumbnailInfo.comments.append(textField.text!)
            textField.text = ""
            tblCommentsList.reloadData()
        }
        return false
    }
    
    // MARK: Event Methods
    @IBAction func onBtnActionLikeOrDislike(_ sender: BounceButton) {
        if sender.tag == 11 {
            sender.setImage(UIImage(named: "heart_filled"), for: UIControl.State.normal)
            
        }
        else if sender.tag == 12 {
            sender.setImage(UIImage(named: "cross_filled"), for: UIControl.State.normal)
        }
        
        sender.setLikeBounce(0.6)
        sender.playAnimate()
        
        guard let view = sender.superview else {
            return
        }
        
        view.layer.borderColor = UIColor.systemRed.cgColor
    
        if sender.tag == 11 {
            btnLike.isUserInteractionEnabled = false
            btnDisLike.isUserInteractionEnabled = false
            _thumbnailInfo?.likesCount += 1
            
            if let thumbnailInfo = _thumbnailInfo {
                lblLikeCounts.text = String(thumbnailInfo.likesCount)
            }
        }
        else if sender.tag == 12 {
            btnLike.isUserInteractionEnabled = false
            btnDisLike.isUserInteractionEnabled = false
        }
    }
    
    @objc func onBtnDelete(sender: UIButton){
        if let thumbnailInfo = _thumbnailInfo {
            thumbnailInfo.comments.remove(at: sender.tag)
        }
        tblCommentsList.reloadData()
    }
    
    @objc func onVideoDidEnterFullscreen(_ notification: Notification) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rotationMode = 0
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @objc func onVideoDidLeaveFullscreen(_ notification: Notification) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rotationMode = 1
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @objc func onKeyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    var newHeight: CGFloat
                    let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                    let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                    let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                    let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                    if #available(iOS 11.0, *) {
                        newHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
                    } else {
                        newHeight = keyboardFrame.cgRectValue.height
                    }
                    let keyboardHeight = newHeight + 10
                    UIView.animate(withDuration: duration,
                                   delay: TimeInterval(0),
                                   options: animationCurve,
                                   animations: {
                                    self.textFieldBottomConstraint.constant = keyboardHeight
                                    self.view.layoutIfNeeded()
                                    
                                   },
                                   completion: nil)
                }
        }
    }

    @objc public func onKeyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let _: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                    let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                    let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                    let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                    
                    UIView.animate(withDuration: duration,
                                   delay: TimeInterval(0),
                                   options: animationCurve,
                                   animations: {
                                    self.textFieldBottomConstraint.constant = 0
                                    self.view.layoutIfNeeded()
                                    
                                   },
                                   completion: nil)
                }
        }
    }
    
}
