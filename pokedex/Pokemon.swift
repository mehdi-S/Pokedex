//
//  Pokemon.swift
//  pokedex
//
//  Created by Mehdi Silini on 27/05/2016.
//  Copyright © 2016 Mehdi Silini. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextevolutionText: String!
    private var _nextevolutionId: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var description: String {
        
            if _description == nil {
                _description = ERR_NIL_DATA
            }
        return _description
    }
    var type: String {
        
            if _type == nil {
                _type = ERR_NIL_DATA
            }
        return _type
    }
    var defense: String {
        
            if _defense == nil {
                _defense = ERR_NIL_DATA
            }
        return _defense
    }
    var attack: String {
        
            if _attack == nil {
                _attack = ERR_NIL_DATA
            }
        return _attack
    }
    var height: String {
        
            if _height == nil {
                _height = ERR_NIL_DATA
            }
        return _height
    }
    var weight: String {
        
            if _weight == nil {
                _weight = ERR_NIL_DATA
            }
        return _weight
    }
    var nextevolutionText: String {
        
            if _nextevolutionText == nil {
                _nextevolutionText = ERR_NIL_DATA
            }
        return _nextevolutionText
    }
    var nextevolutionId: String {
        
            if _nextevolutionId == nil {
                _nextevolutionId = ERR_NIL_DATA
            }
        return _nextevolutionId
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] where stats.count > 0 {
                    if let attack = stats[4]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                    if let defense = stats[3]["base_stat"] as? Int {
                        self._defense = "\(defense)"
                    }
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] where types.count > 0 {
                    
                    if let type1dict = types[0]["type"] as? Dictionary<String, String> {
                        if let type1 = type1dict["name"] {
                            self._type = type1.capitalizedString
                        }
                    }
                    if types.count > 1 {
                        if let type2dict = types[1]["type"] as? Dictionary<String, String> {
                            if let type2 = type2dict["name"] {
                                self._type! += " / \(type2)".capitalizedString
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArray = dict["species"] as? Dictionary<String, String> {
                    if let url = descArray["url"] {
                        let nsurl = NSURL(string: url)!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                        
                            let descResult = response.result
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                if let pkmnFlavor = descDict["flavor_text_entries"] as? [Dictionary<String, AnyObject>] {
                                    if let pkmnDesc = pkmnFlavor[1]["flavor_text"] as? String {
                                        self._description = pkmnDesc
                                        print("description: " + self._description)
                                    }
                                }
                                if let evolve = descDict["evolves_from_species"] as? Dictionary<String, AnyObject> {
                                    if let evolvePkmnName = evolve["name"] as? String {
                                        if let urlstr = evolve["url"] as? String {
                                            let strId = urlstr.stringByReplacingOccurrencesOfString("https://pokeapi.co/api/v2/pokemon-species/", withString: "")
                                            let pkmnNumber = strId.stringByReplacingOccurrencesOfString("/", withString: "")
                                            
                                            self._nextevolutionId = pkmnNumber
                                            self._nextevolutionText = "\(self.name.capitalizedString) evolve from \(evolvePkmnName.capitalizedString)"
                                        }
                                        //evolved pokemon
                                    }
                                } else {
                                    self._nextevolutionText = "\(self.name.capitalizedString) is the first form of his species"
                                    self._nextevolutionId = "-1"
                                }
                            }
                        completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                

                
                
                
                
                print("height :" + self._height)
                print("weight :" + self._weight)
                print("attack :" + self._attack)
                print("defense :" + self._defense)
                print("type :" + self._type)
                
            }
        }
    }
}