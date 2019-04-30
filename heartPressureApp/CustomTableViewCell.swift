//
//  CustomTableViewCell.swift
//  heartPressureApp
//
//  Created by Alumno on 4/30/19.
//  Copyright © 2019 Isabela Escalante. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbPulso: UILabel!
    @IBOutlet weak var lbDistolica: UILabel!
    @IBOutlet weak var lbSistolica: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
