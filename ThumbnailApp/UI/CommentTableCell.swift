
import UIKit

class CommentTableCell: UITableViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblComment: PaddedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
