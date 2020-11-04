
import UIKit
import WebKit

// MARK: Logic Method
internal extension DetailViewController {
    
    ///Method to find the correct youtube video
    func findVideo(caption: String) -> String {
        var urlAddress:String = ""
        switch (caption) {
            case "Lonely Railroad":
                urlAddress = "https://youtu.be/-xNus37RhWA"
                break
            case "Autumn Path":
                urlAddress = "https://youtu.be/Go4YMAws6BU"
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
                urlAddress = "https://youtu.be/ftgX04OOmNw"
                break
            case "Red House":
                urlAddress = "https://youtu.be/ZZJ6tGRiI9k"
                break
            default:
                break
        }
        
        return urlAddress
    }
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    public var _thumbnailInfo:ThumbnailInfo?
    var _urlAddress: String = ""
    var _cellHeight: CGFloat = 80

    // MARK : Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblCaption.text = _thumbnailInfo?.caption
        lblCaption.textColor = UIColor.systemOrange
        
        viewWrapperCount.isHidden = true
        viewWrapperDisLikes.isHidden = true
        viewWrapperLikes.isHidden = true
        
        btnLike.tag = 11
        btnLike.isUserInteractionEnabled = true
        viewWrapperLikes.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        viewWrapperLikes.layer.masksToBounds = false
        viewWrapperLikes.layer.cornerRadius = viewWrapperLikes.frame.width / 2
        viewWrapperLikes.layer.borderColor = UIColor.systemOrange.cgColor
        viewWrapperLikes.layer.borderWidth = 2.0
        
        btnDisLike.tag = 12
        btnDisLike.isUserInteractionEnabled = true
        viewWrapperDisLikes.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        viewWrapperDisLikes.layer.masksToBounds = false
        viewWrapperDisLikes.layer.cornerRadius = viewWrapperDisLikes.frame.width / 2
        viewWrapperDisLikes.layer.borderColor = UIColor.systemOrange.cgColor
        viewWrapperDisLikes.layer.borderWidth = 2.0
        lblLikeCounts.textColor = UIColor.white
        txtWriteComment.autocorrectionType = .no
        txtWriteComment.delegate = self
        tblCommentsList.tableFooterView = UIView()
        tblCommentsList.separatorStyle = .none;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
            self.viewWrapperCount.isHidden = false
            self.viewWrapperDisLikes.isHidden = false
            self.viewWrapperLikes.isHidden = false
        }
        
        if let thumbnailInfo = _thumbnailInfo {
            lblCaption.text = thumbnailInfo.caption
            lblLikeCounts.text = String(thumbnailInfo.likesCount)
        }
        
        _urlAddress = self.findVideo(caption: _thumbnailInfo?.caption ?? "")
        viewWebViewWrapper.showVideo(urlAddress: self._urlAddress)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        /// Lock the orientation for this view controller
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.allowRotate = false
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func onBtnActionLikeOrDislike(_ sender: BounceButton) {
        if sender.tag == 11 {
            sender.setImage(UIImage(named: "heart_filled"), for: UIControl.State.normal)
            
        }
        else if sender.tag == 12 {
            sender.setImage(UIImage(named: "cross_filled"), for: UIControl.State.normal)
        }
        
        sender.likeBounce(0.6)
        sender.animate()
        
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
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return _cellHeight
    }
    
    // MARK: Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        if let thumbnailInfo = _thumbnailInfo {
            thumbnailInfo.comments.append(textField.text!)
            textField.text = ""
            tblCommentsList.reloadData()
        }
        return false
    }
    
    // MARK: Event Methods
    @objc public func keyboardWillShow(notification: NSNotification) {
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

    @objc public func keyboardWillHide(notification: NSNotification) {
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
    
    @objc func onBtnDelete(sender: UIButton){
        if let thumbnailInfo = _thumbnailInfo {
            thumbnailInfo.comments.remove(at: sender.tag)
        }
        tblCommentsList.reloadData()
    }

}
