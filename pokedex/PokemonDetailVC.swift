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
    
    @IBOutlet weak var biographieStackView: UIStackView!
    @IBOutlet weak var evolutionStackView: UIStackView!
    @IBOutlet weak var evolutionHeaderView: UIView!
    @IBOutlet weak var movesTableView: UITableView!
    
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
        
        self.movesTableView.delegate = self
        self.movesTableView.dataSource = self
        self.movesTableView.hidden = true
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
    
    @IBAction func segmentControlPressed(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            movesTableView.hidden = true
            biographieStackView.hidden = false
            evolutionStackView.hidden = false
            evolutionHeaderView.hidden = false
        } else if sender.selectedSegmentIndex == 1 {
            movesTableView.hidden = false
            biographieStackView.hidden = true
            evolutionStackView.hidden = true
            evolutionHeaderView.hidden = true
            movesTableView.reloadData()
        }
    }
}

extension PokemonDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemon.moves.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let moveCell = movesTableView.dequeueReusableCellWithIdentifier("MoveCell", forIndexPath: indexPath) as? MoveCell {
            moveCell.configureCell(pokemon.moves[indexPath.row])
            
            return moveCell
        } else {
            let cell = MoveCell()
            cell.configureCell(pokemon.moves[indexPath.row])
            
            return cell
        }
    }
}
