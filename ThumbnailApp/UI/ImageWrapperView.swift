
import UIKit

class ThumbnailView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    var imageWrappedView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.isUserInteractionEnabled = false

        return spinner
    }()

    func setupView() {
        self.addSubview(imageWrappedView)
        self.addSubview(spinner)

        addConstraint(NSLayoutConstraint.constraints(withVisualFormat: ("H:|-8-[v0]-8-|"), options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageWrappedView])[0])

        addConstraint(NSLayoutConstraint.constraints(withVisualFormat: ("V:|-8-[v0]-8-|"), options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageWrappedView])[0])

    }


}
