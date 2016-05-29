//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Mehdi Silini on 27/05/2016.
//  Copyright © 2016 Mehdi Silini. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var defenseLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var pokedexidLabel: UILabel!
    
    @IBOutlet weak var baseattackLabel: UILabel!
    
    @IBOutlet weak var evolutionLabel: UILabel!
    
    @IBOutlet weak var firstpkmnImage: UIImageView!
    
    @IBOutlet weak var secondpkmnImage: UIImageView!
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNameLabel.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = img
        secondpkmnImage.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            print("GETTOUT OF ERE")
            self.updateUI()
        }
    }

    
    func updateUI() {
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        baseattackLabel.text = pokemon.attack
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        pokedexidLabel.text = "\(pokemon.pokedexId)"
        evolutionLabel.text = pokemon.nextevolutionText
        if pokemon.nextevolutionId != "-1" {
            firstpkmnImage.image = UIImage(named: pokemon.nextevolutionId)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
