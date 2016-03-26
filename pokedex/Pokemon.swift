//
//  Pokemon.swift
//  pokedex
//
//  Created by Kersuzan on 26/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import Foundation

class Pokemon {
    
    // Private variables
    private var _name: String!
    private var _pokedexId: Int!
    
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
    }
    
}