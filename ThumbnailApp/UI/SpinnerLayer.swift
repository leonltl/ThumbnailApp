
import UIKit

internal class SpinnerLayer: CAShapeLayer {
    
    // MARK: - Properties
    internal var length: CGFloat = 32.0
    var color: CGColor? = UIColor.white.cgColor {
        willSet {
            strokeColor = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect) {
        super.init()
        setUp(frame: frame)
    }
    
    /// Setup the ux properties and constraints
    func setUp(frame: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: length, height: length)
        let center = CGPoint(x: (frame.width / 2) - (length / 2), y: frame.height/2 - (length / 2))
        
        let circlePath = UIBezierPath(arcCenter: center, radius: 10, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        self.path = circlePath.cgPath
        lineWidth = 2.0
        strokeColor = color
        fillColor = UIColor.clear.cgColor
        
        self.isHidden = true
    }
    
    /// Update the framee
    func update(frame: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        let center = CGPoint(x: (frame.width / 2), y: frame.height/2 - (frame.width / 8))
        
        let circlePath = UIBezierPath(arcCenter: center, radius: 10, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        self.path = circlePath.cgPath
    }
}

// MARK: Animation Methods
internal extension SpinnerLayer {
    
    /// Animation logic
    func startAnimation() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        
        add(animationGroup, forKey: nil)
    }
    
    func stopAnimation() {
        removeAllAnimations()
    }
}
