//
//  StageNameViewCell.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 5/21/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit

class StageNameViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var name : String {
        set {
            nameLabel.text = newValue
        }
        
        get {
            return nameLabel.text!
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
