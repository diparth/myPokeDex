//
//  PokeCell.swift
//  PokeDex
//
//  Created by Diparth Patel on 6/27/17.
//  Copyright © 2017 Diparth Patel. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemonImage.image = UIImage.init(named: "\(pokemon.pokeID)")
        self.pokemonLabel.text = pokemon.name.capitalized
    }
    
}
