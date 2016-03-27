//
//  Pokemon.swift
//  pokedex
//
//  Created by Kersuzan on 26/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    // Private variables
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonUrl: String!
    
    // Getters
    var name: String! {
        return _name
    }
    
    var pokedexId: Int! {
        return _pokedexId
    }
    
    // Initializer
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        Alamofire.request(.GET, NSURL(string: self._pokemonUrl)!).responseJSON { (response: Response<AnyObject, NSError>) in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
            
                if let types = dict["types"] as? Array<Dictionary<String, String>> where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                print(self._type)
            }
        }
    }
    
}