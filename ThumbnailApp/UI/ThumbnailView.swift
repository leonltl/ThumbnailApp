
import UIKit

// MARK: - Methods to download the image from web
internal extension ThumbnailView {
    
    /// download the images
    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        if (spinner.isHidden) {
            spinner.isHidden = false
            spinner.startAnimation()
        }
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() { [weak self] in
                    self?.spinner.isHidden = true
                    self?.spinner.stopAnimation()
                }
                return
            }
            
            guard let imageData = UIImage(data: data) else {
                DispatchQueue.main.async() { [weak self] in
                    self?.spinner.isHidden = true
                    self?.spinner.stopAnimation()
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.thumbnailImage.image = imageData
                self?.spinner.isHidden = true
                self?.spinner.stopAnimation()
            }
        }.resume()
        
    }
    
    /// download the images
    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        spinner.isHidden = false
        spinner.startAnimation()
        
        guard let url = URL(string: link) else {
            return
        }
        download(from: url, contentMode: mode)
    }
}

class ThumbnailView: UIView {
    
    internal var animationDuration: CFTimeInterval = 0.1
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    internal lazy var thumbnailImage:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        return imageView
    }()

    // Sets the duration of the animations
    public var duration: Double = 0.2 {
        willSet {
            animationDuration = newValue
        }
    }
    
    internal lazy var spinner: SpinnerLayer = {
        let spinner = SpinnerLayer(frame: self.bounds)
        self.layer.addSublayer(spinner)
        return spinner
    }()
    
   
    /// Sets the spinner color
    public var spinnerColor: CGColor? {
        willSet {
            spinner.color = newValue
        }
    }
    
    func setUp() {
        // thunbnail constraint
        let thumbnailHConstraints = NSLayoutConstraint.constraints(withVisualFormat: ("H:|-0-[v0]-0-|"), options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": thumbnailImage])
        let thumbnailVConstraints = NSLayoutConstraint.constraints(withVisualFormat: ("V:|-0-[v0]-0-|"), options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": thumbnailImage])
        addConstraints(thumbnailHConstraints)
        addConstraints(thumbnailVConstraints)
        
        // thunbnail corner radius
        thumbnailImage.layer.cornerRadius = 10

        // thunbnail shadow
        thumbnailImage.layer.shadowColor = UIColor.black.cgColor
        thumbnailImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        thumbnailImage.layer.shadowOpacity = 0.7
        thumbnailImage.layer.shadowRadius = 4.0
        
        self.spinner.color = UIColor.systemOrange.cgColor
    }
}