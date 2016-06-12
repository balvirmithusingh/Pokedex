//
//  PokemonViewCell.swift
//  PokeDex
//
//  Created by Balvir Singh on 6/7/16.
//  Copyright © 2016 Balvir Singh. All rights reserved.
//

import UIKit

class PokemonViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonNameLbl: UILabel!
    
    func configureCell(pokemon: Pokemon){
        self.pokemonImg.image = UIImage(named: "\(pokemon.pokedexID)")
        self.pokemonNameLbl.text = pokemon.name.capitalizedString
    }
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 10.0
        
    }
    
}
