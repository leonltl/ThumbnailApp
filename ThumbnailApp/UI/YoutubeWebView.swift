import UIKit
import WebKit

class VideoWebView: WKWebView {
    
    var urlAddress = "" {
        didSet {
            self.urls = urlAddress.extractURLs()
        }
    }

    var urls = [URL]() {
        didSet {
            refreshContents()
        }
    }

    private var playsInline: Bool = false

    /// Allows you to initialize the view with a prepopulated text and customizing whether to play videos inline.
    /// - Parameters:
    ///   - text: The text to extract video urls from
    ///   - allowInlinePlayback: Whether to allow video to play inline rather than always being full screen.
    ///       If set to true, then video will start playing inline by default.
    public convenience init(frame: CGRect, urlAddress: String, allowInlinePlayback: Bool = false) {
        let webConfiguration = WKWebViewConfiguration()
        if (allowInlinePlayback) {
            webConfiguration.allowsInlineMediaPlayback = true
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        }

        self.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), configuration: webConfiguration)

        self.playsInline = allowInlinePlayback

        self.scrollView.isScrollEnabled = false

        self.urlAddress = urlAddress
        // NOTE: These two lines would normally be called by the didSet on text, but not if you're in an initializer
        self.urls = urlAddress.extractURLs()
        refreshContents()
    }

    /// - Returns
    ///    Whether this instance has urls it thinks it will be able to render
    func containsURLs() -> Bool {
        return self.urls.contains { (url) -> Bool in
            return url.host?.contains("youtu") ?? url.host?.contains("vimeo.com") ?? false
        }
    }

    /// - Returns
    ///    The contents of `text` with the extracted video urls removed
    func textWithoutURLs() -> String{
        var result = self.urlAddress

        // If URL is in the middle of the text it will create a double space, but that's okay for now
        for url in self.urls {
            result = result.replacingOccurrences(of: "\(url.absoluteString)", with: "")
        }

        return result
    }
    
    func playVideo() {
        // NOTE: These two lines would normally be called by the didSet on text, but not if you're in an initializer
        self.urls = urlAddress.extractURLs()
        refreshContents()
    }

    /// Called whenever the URLs are updated (or you can call it manually) to load the first video url found in text or set in URLs
    /// into the body of this webview.
    func refreshContents() {

        for url in self.urls {
            let videoLink: String?

            if(url.host?.contains("youtu") ?? false) {

                // Fool proof video ID decoding
                let host = "https://www.youtube.com/embed/"
                let query = playsInline ? "?rel=0&playsinline=1" : "?rel=0"
                if (url.host?.contains("youtube.com") ?? false) {
                    guard let url = URLComponents(string: url.absoluteString) else {
                        videoLink = host + query
                        return
                    }
                    
                    let param = url.queryItems?.first(where: { $0.name == "v" })?.value ?? ""
                    videoLink = host + param + query
                }
                else if (url.host?.contains("youtu.be") ?? false) {
                    videoLink = host + url.lastPathComponent + query
                }
                else {
                    videoLink = nil
                }
            }
            else {
                videoLink = nil
            }

            // Ok, if we found a video there, load it into the pane and then stop searching
            if let link = videoLink {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.loadHTMLString(self.iframeForLink(link), baseURL: nil)
                })

                break
            }
        }
    }

    internal func iframeForLink(_ link: String) -> String {
        return "<head> <meta name=viewport content='width=device-width, initial-scale=1'><style type='text/css'> body { margin: 0;} </style></head><iframe src='\(link)' width='100%' height='100%' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
    }
}
