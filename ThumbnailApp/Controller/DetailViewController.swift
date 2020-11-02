
import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var viewWebViewWrapper: UIView!
    
    public var caption:String = ""
    
    internal lazy var webView:VideoWebView = {
        let webView = VideoWebView(frame: self.viewWebViewWrapper.frame, urlAddress: "", allowInlinePlayback: true)
        self.viewWebViewWrapper.addSubview(webView)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblCaption.text = caption
        lblCaption.textColor = UIColor.systemOrange
        
        //let webViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: ("H:|-0-[v0]-0-|"), options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": self.webView])
        //let webViewVConstraints = NSLayoutConstraint.constraints(withVisualFormat: ("V:|-0-[v0]-0-|"), options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": self.webView])
        
        //viewWebViewWrapper.addConstraints(webViewHConstraints)
        //viewWebViewWrapper.addConstraints(webViewVConstraints)
        
        
        switch (caption) {
            case "Lonely Railroad":
                self.webView.urlAddress = "https://youtu.be/-xNus37RhWA"
                self.webView.playVideo()
                break
            case "Autumn Path":
                self.webView.urlAddress = "https://youtu.be/Go4YMAws6BU"
                self.webView.playVideo()
                break
            case "Cloudy Hill":
                self.webView.urlAddress = "https://youtu.be/ivjZWCU9pKA"
                self.webView.playVideo()
                break
            default:
                break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: self.viewWebViewWrapper.frame.width, height: self.viewWebViewWrapper.frame.height)
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
