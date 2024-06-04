//
//  HistoryTableViewCell.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var waterIntakeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
