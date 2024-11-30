//
//  HistoryTableViewCell.swift
//  AlertWise
//
//  Created by William Chrisandy on 26/11/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellContentLbl: UILabel!
    @IBOutlet weak var cellSubContentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.image = UIImage(named: "lock")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
