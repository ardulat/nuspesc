//
//  QuizTableViewCell.swift
//  Doner
//
//  Created by MacBook on 07.11.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
