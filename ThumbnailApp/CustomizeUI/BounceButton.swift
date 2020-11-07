
import UIKit

class BounceButton: UIButton{

    var bounceView:BounceView!
    
    //MARK: Init
    override init (frame : CGRect) {
        super.init(frame : frame)
        setUp()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        setUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bounceView.frame = self.bounds
        self.insertSubview(self.bounceView, at: 0)
    }
    
    // MARK: Setup
    func setUp(){
        self.clipsToBounds = false;
        
        self.bounceView = BounceView()
        //self.sparkView.backgroundColor = UIColor.redColor()
        self.insertSubview(self.bounceView, at: 0)
    }
    
    func playAnimate () {
        let delay = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.bounceView.animate()
        };
    }

    // MARK: Animations
    func setLikeBounce (_ duration: TimeInterval) {
        self.transform = CGAffineTransform.identity
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.6, y: 1.6);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            })
            
            }, completion: {finished in
                
        })
        
    }
    
    func setUnLikeBounce (_ duration: TimeInterval) {
        self.transform = CGAffineTransform.identity
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6);
            })
                        
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
            })
            
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            })
            
            }, completion: {finished in
                
        })
        
    }

}
