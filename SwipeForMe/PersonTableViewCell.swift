//
//  PersonTableViewCell.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/3/21.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var campusLabel: UILabel!
    
    var person: Person! {
        didSet {
            nameLabel.text = person.name
            statusLabel.text = person.status
            campusLabel.text = person.campus
        }
    }

}
