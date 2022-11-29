//
//  HistoryTableViewCell.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 20.11.2022.
//

import UIKit

struct HistoryTableViewCellModelView {
    let date: String
    let number: String
    let infoText: String
}

class HistoryTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var infotextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        numberLabel.text = nil
        infotextLabel.text = nil
    }
    
    func config(model: HistoryTableViewCellModelView) {
        dateLabel.text = model.date
        numberLabel.text = model.number
        infotextLabel.text = model.infoText
    }
    
}
