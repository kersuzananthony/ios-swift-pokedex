//
//  Move.swift
//  pokedex
//
//  Created by Kersuzan on 27/03/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import Foundation

class Move {
    
    private var _name: String!
    private var _moveDescription: String!
    private var _accuracy: String!
    private var _power: String!
    
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            
            return _name
        }
    }
    
    var moveDescription: String {
        get {
            if _moveDescription == nil {
                _moveDescription = ""
            }
            
            return _moveDescription
        }
    }
    
    var accuracy: String {
        get {
            if _accuracy == nil {
                _accuracy = ""
            }
            
            return _accuracy
        }
    }
    
    var power: String {
        get {
            if _power == nil {
                _power = ""
            }
            
            return _power
        }
    }
    
    init(name: String, description: String, accuracy: String, power: String) {
        self._name = name
        self._moveDescription = description
        self._accuracy = accuracy
        self._power = power
    }
    
}
