//
//  MoveCell.swift
//  pokedex
//
//  Created by Kersuzan on 27/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.layer.cornerRadius = 5.0
        self.nameLabel.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(move: Move) {
        self.nameLabel.text = move.name
        self.descriptionLabel.text = move.moveDescription
        self.accuracyLabel.text = move.accuracy
        self.powerLabel.text = move.power
    }

}
