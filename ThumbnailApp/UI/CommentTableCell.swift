//
//  CommeentTableCell.swift
//  ThumbnailApp
//
//  Created by Leonard Lim on 4/11/20.
//

import UIKit

class CommentTableCell: UITableViewCell {

    
    
    @IBOutlet weak var lblComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
