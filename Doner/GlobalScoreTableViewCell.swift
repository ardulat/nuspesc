//
//  GlobalScoreTableViewCell.swift
//  Doner
//
//  Created by MacBook on 31.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class GlobalScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quizScoreLabel: UILabel!
    @IBOutlet weak var bonusScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
