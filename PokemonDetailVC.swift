//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Balvir Singh on 6/8/16.
//  Copyright © 2016 Balvir Singh. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var detailedPokemon: Pokemon!

    @IBOutlet weak var pokemonMainImg: UIImageView!

    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var type: UILabel!

    @IBOutlet weak var abilityLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var evolutionImg1: UIImageView!
    
    @IBOutlet weak var evolutionImg2: UIImageView!
    
    @IBOutlet weak var heightLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedPokemon.downloadPokemonInfo {
            
            self.updateUI()
            
        }
    }
    
    func updateUI (){
        pokemonMainImg.image = UIImage(named: String(detailedPokemon.pokedexID))
        evolutionImg1.image = pokemonMainImg.image
        evolutionImg2.image = UIImage(named: detailedPokemon.evolutionID)
        heightLbl.text = detailedPokemon.height
        weightLbl.text = detailedPokemon.weight
        abilityLbl.text = detailedPokemon.abilities
        type.text = detailedPokemon.type
        
    }

   
    

}
