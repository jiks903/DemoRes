//
//  MenuItemsSubCell.swift
//  DemoRes
//
//  Created by Jeegnesh Solanki on 01/04/25.
//

import UIKit

class MenuItemsSubCell: UITableViewCell {

    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
