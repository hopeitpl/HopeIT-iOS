//
//  JourneyCell.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

protocol JourneyCellDelegate: class {
    func didTapEdit(journey: Journey)
}

class JourneyCell: UITableViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var planetImage: UIImageView!

    
    var journey: Journey!
    weak var delegate: JourneyCellDelegate?
    
    func set(journey: Journey) {
        self.journey = journey
        titleLabel.text = journey.name
        descLabel.text = journey.desc
        titleLabel.textColor = UIColor.white
        descLabel.textColor = UIColor.white
        planetImage.image = UIImage(named: journey.imageName)
        backgroundColor = journey.tintColor
    }
    
    @IBAction func didTapSettings(_ sender: Any) {
        delegate?.didTapEdit(journey: journey)
    }
}
