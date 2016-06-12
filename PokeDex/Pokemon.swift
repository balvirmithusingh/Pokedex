//
//  Pokemon.swift
//  PokeDex
//
//  Created by Balvir Singh on 6/6/16.
//  Copyright © 2016 Balvir Singh. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _desc: String?
    private var _type: String!
    private var _abilities: String!
    private var _height: String!
    private var _weight: String!
    private var _pokemonURL: String!
    private var _evolutionID: String!
    
    
    
    var name: String{
            return _name
    }
    
    var pokedexID: Int{
        return _pokedexID
    }
    
    var desc: String?{
        return _desc
    }
    
    var type: String{
        return _type
    }
    
    var abilities: String{
        return _abilities
    }
    
    var height: String{
        return _height
    }
    
    var weight: String{
        return _weight
    }
    
    var evolutionID: String{
        return _evolutionID
    }
    
    init(name: String, ID: Int){
        self._name = name
        self._pokedexID = ID
        _pokemonURL = "\(BASE_URL)\(self._pokedexID)/"
    }
    
    func downloadPokemonInfo(closure: DownloadCompletedClosure){
        
        let url = NSURL(string: _pokemonURL)!
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            
            if let pokemonDict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let height = pokemonDict["height"] as? String, let weight = pokemonDict["weight"] as? String{
                    
                    if let pokemonAbilities = pokemonDict["abilities"] as? [Dictionary<String,AnyObject>]{
                        
                        var abilitiesStr = ""
                    
                        for ability in pokemonAbilities{
                            
                            if let abilityName = ability["name"] as? String{
                                abilitiesStr = abilitiesStr + abilityName + ","
                            }
                            
                        }
                        
                        let beautifiedAbilitiesStr = String(abilitiesStr.characters.dropLast()).capitalizedString
                        
                        self._abilities = beautifiedAbilitiesStr
                        self._height = height
                        self._weight = weight
                    }
                }
                
                if let evolutionsArray = pokemonDict["evolutions"] as? NSArray{
                    if let evolutionTo = evolutionsArray[0]["to"] as? String{
                        if evolutionTo.rangeOfString("mega") == nil{
                            if let evolutionURL = evolutionsArray[0]["resource_uri"] as? String{
                                let modifiedURL = evolutionURL.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let evolutionsID = modifiedURL.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._evolutionID = evolutionsID
                            }
                        }
                    }
                }
                
                if let typesArray = pokemonDict["types"] as? NSArray{
                    
                    var typesStr = ""
                    
                    for type in typesArray{
                        
                        if let typeName = type["name"] as? String{
                            typesStr = typesStr + typeName + ","
                        }
                        
                    }
                    
                    let beautifiedTypesStr = String(typesStr.characters.dropLast()).capitalizedString
                    self._type = beautifiedTypesStr
                    
                }
                
                if let descriptionArray = pokemonDict["descriptions"] as? NSArray{
                    
                    if let descriptionURL = descriptionArray[0]["resource_uri"] as? String{
                        
                        if let descrNsurl = NSURL(string: "http://pokeapi.co\(descriptionURL)"){
                            
                            Alamofire.request(.GET, descrNsurl).responseJSON(completionHandler: { (
                                response) in
                                
                                if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                    
                                    if let descriptionSentence = descDict["description"] as? String{
                                        self._desc = descriptionSentence
                                        print (self._desc)
                                    }
                                    
                                    closure()
                                }
                            })

                        }
                    }
                }else{
                    self._desc = ""
                }
            }
            
            print(self._height)
            print(self.weight)
            print(self._abilities)
            print(self._type)
            print(self._evolutionID)
         
            
        }
        
       
    }

}
