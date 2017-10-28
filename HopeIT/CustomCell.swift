//
//  CustomCell.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var mainLAbel: UILabel!
    @IBOutlet weak var subLAbel: UILabel!
    @IBOutlet weak var container: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 5.0
        container.clipsToBounds = true
        container.dropShadow()
    }
    
}
