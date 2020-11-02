import UIKit

public enum AnimationType {
    /// Collapse animation will make the button round and show the spinner
    case collapse
    /// Expand animation will make the button go back to the defaults, use after button is "collapsed"
    case expand
}


public class SpinnerButton: UIButton {
    // MARK: - Properties
    internal var storedTitle: String?
    internal var animationDuration: CFTimeInterval = 0.1
    
    /// Sets the button corner radius
    public var cornerRadius: CGFloat = 5 {
        willSet {
            layer.cornerRadius = newValue
        }
    }
    
    /// Sets the duration of the animations
    public var duration: Double = 0.2 {
        willSet {
            animationDuration = newValue
        }
    }
    
    internal lazy var spinner: SpinnerLayer = {
        let spinner = SpinnerLayer(frame: self.frame)
        self.layer.addSublayer(spinner)
        return spinner
    }()
    
   
    /// Sets the spinner color
    public var spinnerColor: CGColor? {
        willSet {
            spinner.color = newValue
        }
    }
    
    /// Sets the button title for its normal state
    public var title: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    /// Sets the button title color.
    public var titleColor: UIColor? {
        get {
            return self.titleColor(for: .normal)
        }
        set {
            self.setTitleColor(newValue, for: .normal)
        }
    }
    
    // MARK: - Initializers
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setUp()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        
        let spinnerFrame =  CGRect(x: 0, y: 0, width: 32, height: 40)
        self.spinner.update(frame: spinnerFrame)
    }
    
    func setUp() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.backgroundColor = UIColor.systemOrange
        self.titleColor = UIColor.white
    }
}


// MARK: - Animation Methods
internal extension SpinnerButton {
    
    func collapseAnimation() {
        storedTitle = title
        title = ""
        isUserInteractionEnabled = false
        
        let animaton = CABasicAnimation(keyPath: "bounds.size.width")
        animaton.fromValue = frame.width
        animaton.toValue =  frame.height
        animaton.duration = animationDuration
        animaton.fillMode = CAMediaTimingFillMode.forwards
        animaton.isRemovedOnCompletion = false
        
        layer.add(animaton, forKey: animaton.keyPath)
        spinner.isHidden = false
        spinner.startAnimation()
    }
    
    func backToDefaults() {
        spinner.stopAnimation()
        setTitle(storedTitle, for: .normal)
        isUserInteractionEnabled = true
        
        let animaton = CABasicAnimation(keyPath: "bounds.size.width")
        animaton.fromValue = frame.height
        animaton.toValue = frame.width
        animaton.duration = animationDuration
        animaton.fillMode = CAMediaTimingFillMode.forwards
        animaton.isRemovedOnCompletion = false
        
        layer.add(animaton, forKey: animaton.keyPath)
        spinner.isHidden = true
    }
    
}

// MARK: - Public Methods
public extension SpinnerButton {
    
    /**
     Animates the the button with the given animation
     - parameter animation: Type of animation that will be executed
     */
    func animate(animation: AnimationType) {
        
        switch animation {
            case .collapse:
                UIView.animate(withDuration: 0.1, animations: {
                    self.layer.cornerRadius = self.frame.height/2
                }, completion: { (completion) in
                    self.collapseAnimation()
                })
                
            case .expand:
                UIView.animate(withDuration: 0.1, animations: {
                    self.layer.cornerRadius = self.cornerRadius
                }, completion: { (completion) in
                    self.backToDefaults()
                })
        }
    }
}
