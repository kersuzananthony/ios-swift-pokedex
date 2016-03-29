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
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    private var _moves: Array<Move>! = [Move]()
    
    // Getters
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            
            return _name
        }
    }
    
    var pokedexId: Int {
        get {
            if _pokedexId == nil {
                _pokedexId = 0
            }
            
            return _pokedexId
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            
            return _description
        }
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        
        return _nextEvolutionText
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
         return _nextEvolutionId
    }
    
    var moves: Array<Move> {
        return _moves
    }
    
    // Initializer
    init(name: String, pokedexId: Int) {
        self._name = name.capitalizedString
        self._pokedexId = pokedexId
        
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete, movesDownloadCompleted: DownloadComplete) {
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
                
                if let evolutionsArray = dict["evolutions"] as? Array<Dictionary<String, AnyObject>> where evolutionsArray.count > 0 {
                    if let toEvolution = evolutionsArray[0]["to"] as? String {
                        // Exclude mega evolution since we do not have asset for it
                        if toEvolution.rangeOfString("mega") == nil {
                            if let uri = evolutionsArray[0]["resource_uri"] as? String {
                                let evolutionId = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "").stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = evolutionId
                                self._nextEvolutionText = toEvolution
                                
                                if let level = evolutionsArray[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
    
                // Descriptions
                if let descriptionsArray = dict["descriptions"] as? Array<Dictionary<String, String>> where descriptionsArray.count > 0 {
                    if let url = descriptionsArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(Method.GET, nsurl).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                            let result = response.result
                            
                            if let dicResult = result.value as? Dictionary<String, AnyObject> {
                                if let description = dicResult["description"] as? String {
                                    self._description = description
                                }
                            }
                            
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                // Moves
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>] where moves.count > 0 {
                    
                    var moveName = ""
                    var moveDesc = ""
                    var movePower = ""
                    var moveAccuracy = ""
                    
                    for i in 0 ..< moves.count {
                        if let url = moves[i]["resource_uri"] as? String {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            Alamofire.request(.GET, nsurl).responseJSON { (response: Response<AnyObject, NSError>) in
                                
                                let moveResult = response.result
                                
                                if let moveDict = moveResult.value as? Dictionary<String, AnyObject> {
                                    
                                    if let name = moveDict["name"] as? String {
                                        moveName = name
                                    }
                                    
                                    if let desc = moveDict["description"] as? String {
                                        moveDesc = desc
                                    }
                                    
                                    if let power = moveDict["power"] as? Int {
                                        movePower = "\(power)"
                                    }
                                    
                                    if let accuracy = moveDict["accuracy"] as? Int {
                                        moveAccuracy = "\(accuracy)"
                                    }
                                    
                                    let move = Move(name: moveName, description: moveDesc, accuracy: moveAccuracy, power: movePower)
                                    
                                    self._moves.append(move)
                                    
                                    if i + 1 == moves.count {
                                        movesDownloadCompleted()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}