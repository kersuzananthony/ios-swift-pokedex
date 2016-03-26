//
//  PokeCell.swift
//  pokedex
//
//  Created by Kersuzan on 26/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        self.nameLabel.text = self.pokemon.name.capitalizedString
        self.thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}
