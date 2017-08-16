//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Diparth Patel on 7/20/17.
//  Copyright © 2017 Diparth Patel. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {
    var pokemon: Pokemon?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeDescription: UITextView!
    @IBOutlet weak var pokeType: UILabel!
    @IBOutlet weak var pokeDefence: UILabel!
    @IBOutlet weak var pokeHeight: UILabel!
    @IBOutlet weak var pokedexID: UILabel!
    @IBOutlet weak var pokeWeight: UILabel!
    @IBOutlet weak var pokeBaseAttack: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    
    override func viewDidLoad() {
        if pokemon != nil {
            self.name.text = pokemon?.name
        }else {
            name.text = ""
        }
        
        
        pokemon?.downloadPokemonData {
            print("Download Completed!")
            self.pokemon?.fetchDescription {
                self.updateUI()
            }
        }
        
        let pokeImg = UIImage.init(named: "\((pokemon?.pokeID)!)")
        self.pokeImage.image = pokeImg!
        self.currentEvoImage.image = pokeImg!
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        self.pokeHeight.text = pokemon?.height
        self.pokeWeight.text = pokemon?.weight
        self.pokedexID.text = "\((pokemon?.pokeID)!)"
        self.pokeDefence.text = pokemon?.defense
        self.pokeBaseAttack.text = pokemon?.attack
        self.pokeType.text = pokemon?.type
        if pokemon?.nextEvolID != nil {
            self.nextEvoImage.image = UIImage.init(named: (pokemon?.nextEvolID)!)
        }
        self.pokeDescription.text = pokemon?.desc
    }
    
}







