//
//  StepViewCell.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 5/21/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit

class StepViewCell: UITableViewCell {

    @IBOutlet weak var stepName: UILabel!
    
    func setName(newName : String) {
        stepName.text = newName
        print("Updated text name : \(String(describing: stepName.text))")
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
