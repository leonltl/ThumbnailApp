
import UIKit
import WebKit

class VideoView: UIView {
    
    internal var errorImageLen:CGFloat = 210
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal lazy var webView:VideoWebView = {
        let webView = VideoWebView(frame: self.frame, urlAddress: "", allowInlinePlayback: true)
        self.addSubview(webView)
        return webView
    }()
    
    internal lazy var errorImageView:UIImageView = {
        let errorFrame =  CGRect(x: (self.frame.width / 2) - (errorImageLen / 2), y: 20, width: errorImageLen, height: errorImageLen)
        let imageView = UIImageView(frame: errorFrame)
        imageView.image = UIImage(named: "error")
        imageView.isHidden = true
        self.addSubview(imageView)
        return imageView
    }()
    
    /// show the video in webvieew
    func showVideo(urlAddress:String) {
        webView.urlAddress = urlAddress
        webView.playVideo()
    }
    
    /// show error image
    func showError() {
        errorImageView.isHidden = false
    }

}
