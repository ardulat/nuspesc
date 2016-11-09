//
//  EventTableViewCell.swift
//  Doner
//
//  Created by Anuar's mac on 06.11.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTime: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEventCell(time: String, title: String) {
        cellTime.text = time
        cellTitle.text = title
    }

}
