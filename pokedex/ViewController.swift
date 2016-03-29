//
//  ViewController.swift
//  pokedex
//
//  Created by Kersuzan on 24/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons: [Pokemon] = [Pokemon]()
    var filteredPokemons: [Pokemon] = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var isInSearchMode: Bool = false
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        self.collection.delegate = self
        self.collection.dataSource = self
        self.searchBar.delegate = self
        
        self.searchBar.returnKeyType = UIReturnKeyType.Done
        
        parsePokemonCsv()
        initAudio()
    }
    
    func parsePokemonCsv() {
        let pokemonPath = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: pokemonPath)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                self.pokemons.append(Pokemon(name: pokeName, pokedexId: pokeId))
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func initAudio() {
        let musicPath = NSBundle.mainBundle().pathForResource("pokemon_music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: musicPath)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let source: [Pokemon] = isInSearchMode ? filteredPokemons : pokemons
            
            cell.configureCell(source[indexPath.row])
            
            return cell
        } else {
            return UICollectionViewCell()

        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedPokemon: Pokemon = isInSearchMode ? filteredPokemons[indexPath.row] : pokemons[indexPath.row]
        
        performSegueWithIdentifier("PokemonDetailVC", sender: selectedPokemon)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInSearchMode ? filteredPokemons.count : pokemons.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    @IBAction func musicButtonPressed(sender: UIButton) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let destinationVC = segue.destinationViewController as? PokemonDetailVC, pokemon = sender as? Pokemon {
                destinationVC.pokemon = pokemon
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isInSearchMode = false
            filteredPokemons = []
            searchBar.performSelector(#selector(resignFirstResponder), withObject: nil, afterDelay: 0.1)
        } else {
            isInSearchMode = true
            let text = searchBar.text!.lowercaseString
            filteredPokemons = pokemons.filter({ $0.name.rangeOfString(text) != nil })
        }
        
        self.collection.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

