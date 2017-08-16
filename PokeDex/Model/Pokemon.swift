//
//  Pokemon.swift
//  PokeDex
//
//  Created by Diparth Patel on 6/26/17.
//  Copyright © 2017 Diparth Patel. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokeID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolText: String!
    private var _pokeURL: String!
    private var _nextEvolID: String!
    private var _descriptionURL: URL!
    
    
    var name: String {
        return _name
    }
    
    var pokeID: Int {
        return _pokeID
    }
    
    var desc: String {
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var attack: String {
        return _attack
    }
    
    var nextEvolID: String {
        return _nextEvolID
    }
    
    init(name: String, ID: Int) {
        self._name = name
        self._pokeID = ID
        self._pokeURL = "\(BASE_URL)\(POKEMON_URL)\(self.pokeID)/"
        print("Pokemon URL is: \(self._pokeURL)")
    }
    
    var description: Void {
        print("ID: \(self.pokeID) Name: \(self.name)")
    }
    
    func downloadPokemonData(complete: @escaping DownloadComplete) {
        
        let pokeURL = URL.init(string: self._pokeURL)!
        Alamofire.request(pokeURL).responseJSON { (response) in
            
            let result = response.result.value
            if let dict = result as? Dictionary<String, Any> {
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let def = dict["defense"] as? Int {
                    self._defense = "\(def)"
                }
                if let baseAttack = dict["attack"] as? Int {
                    self._attack = "\(baseAttack)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] {
                    var typ = ""
                    for type in types {
                        if type == types.last! {
                            typ = "\(typ)\(type["name"]!.capitalized)"
                        }else {
                            typ = "\(type["name"]!.capitalized)/"
                        }
                    }
                    self._type = typ
                }
                if let dsc = dict["descriptions"] as? [Dictionary<String, Any>] {
                    if let url = dsc[0]["resource_uri"] as? String {
                        let reqUrl = URL.init(string: "\(BASE_URL)\(url)")
                        self._descriptionURL = reqUrl!
                    }
                } else {
                    self._description = ""
                }
                if let evls = dict["evolutions"] as? [Dictionary<String, Any>] {
                    if let url = evls[0]["resource_uri"] as? String {
                        self._nextEvolID = url.replacingOccurrences(of: "/api/v1/pokemon/", with: "").replacingOccurrences(of: "/", with: "")
                    }
                }
            }
            complete()
        }
        
    }
    func fetchDescription(completed: @escaping DownloadComplete) {
        if self._descriptionURL != nil {
            Alamofire.request(self._descriptionURL).responseJSON(completionHandler: { (res) in
                let result = res.result.value
                if let tempDict = result as? Dictionary<String, Any> {
                    if let myDesc = tempDict["description"] as? String {
                        self._description = myDesc.replacingOccurrences(of: "POKMON", with: "Poke´mon")
                    }
                }
                completed()
            })
        }
    }
}




