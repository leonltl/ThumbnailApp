
import UIKit
import WebKit

class VideoView: UIView {

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
    
    /// play the video in wbvieew
    func showVideo(urlAddress:String) {
        webView.urlAddress = urlAddress
        webView.playVideo()
    }

}
