
import UIKit

class PaddedLabel: UILabel {
    
    var topInset: CGFloat = 4.0
    var rightInset: CGFloat = 8.0
    var leftInset: CGFloat = 8.0
    var bottomInset: CGFloat = 4.0
    
    override func drawText(in rect: CGRect) {
        let rect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: rect)
    }
    
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }

    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }

    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)

        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width + leftInset, y: bounds.origin.y + topInset, width: rect.size.width - rightInset, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width + leftInset, y: bounds.origin.y + topInset + (bounds.size.height - rect.size.height) / 2, width: rect.size.width - rightInset, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width + leftInset, y: bounds.origin.y + topInset + (bounds.size.height - rect.size.height), width: rect.size.width - rightInset, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x + leftInset, y: bounds.origin.y + topInset, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x + leftInset, y: bounds.origin.y + topInset + (bounds.size.height - rect.size.height) / 2, width: rect.size.width - rightInset, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x + leftInset, y: bounds.origin.y + topInset + (bounds.size.height - rect.size.height), width: rect.size.width - rightInset, height: rect.size.height)
            }
        }
    }

     
}
