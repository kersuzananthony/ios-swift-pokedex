//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Kersuzan on 26/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evolutionLabel: UILabel!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name.capitalizedString
        pokedexLabel.text = "\(pokemon.pokedexId)"
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.descriptionLabel.text = pokemon.description
        self.typeLabel.text = pokemon.type
        self.defenseLabel.text = pokemon.defense
        self.attackLabel.text = pokemon.attack
        self.heightLabel.text = pokemon.height
        self.weightLabel.text = pokemon.weight
        
        if pokemon.nextEvolutionId != "" {
            self.nextEvoImage.image = UIImage(named: pokemon.nextEvolutionId)
            self.nextEvoImage.hidden = false
            var evolutionText = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLevel != "" {
                evolutionText += " At Lvl \(pokemon.nextEvolutionLevel)"
            }
            
            self.evolutionLabel.text = evolutionText
        } else {
            evolutionLabel.text = "No Evolution"
            self.nextEvoImage.hidden = true
        }
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
