//
//  SurgeryTableViewCell.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 5/29/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit

class SurgeryTableViewCell: UITableViewCell {

    @IBOutlet weak var surgeryNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
