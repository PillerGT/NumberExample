//
//  SecondViewController.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 20.11.2022.
//

import UIKit

class SecondViewController: UIViewController, Storyboardable {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var infoTextView: UITextView!
    
    var model : SecondViewControllerModelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberLabel.text = model.number
        dateLabel.text = model.date
        infoTextView.text = model.infotext
        infoTextView.isUserInteractionEnabled = false
    }
    
}
