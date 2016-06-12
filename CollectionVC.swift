//
//  CollectionVC.swift
//  PokeDex
//
//  Created by Balvir Singh on 6/7/16.
//  Copyright © 2016 Balvir Singh. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer: AVAudioPlayer!
    var arrayOfPokemons = [Pokemon]()
    var filteredArrayOfPokemons = [Pokemon]()
    var userSearchingForPokemon = false
    
    @IBAction func musicBtnPrsd (sender: UIButton){
        
        if musicPlayer.playing{
            musicPlayer.stop()
            
            sender.alpha = 0.5
        }
        else{
            musicPlayer.play()
            
            sender.alpha = 1
        }
    }

    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        let musicURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!)
        do{
            
        musicPlayer = try AVAudioPlayer(contentsOfURL: musicURL)
        
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
        
        parsePokemonCSVFile()
        
    }
    
    func parsePokemonCSVFile(){
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        // type is optional string
        
        do{
        
        let parsedCSVFile = try CSV(contentsOfURL: path)
        
        let parsedCSVFileRows = parsedCSVFile.rows
            
        // type is [Dictionary <string, string>]
            
            for row in parsedCSVFileRows{
                
                let pokemonName = row["identifier"]
                
                let pokemonID = Int(row["id"]!)!
                
                let pokemonObject = Pokemon(name: pokemonName!, ID: pokemonID)
                
                arrayOfPokemons.append(pokemonObject)
            }
        }
        catch let err as NSError{
        print (err.debugDescription)
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if userSearchingForPokemon{
            
            return filteredArrayOfPokemons.count
            
        }else{
            
        return arrayOfPokemons.count
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonViewCell{
            
            if userSearchingForPokemon{
                
                cell.configureCell(filteredArrayOfPokemons[indexPath.row])
            }else{
            
            cell.configureCell(arrayOfPokemons[indexPath.row])
            }
            
            return cell
        }
        
        return PokemonViewCell()
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if userSearchingForPokemon{
            let selectedPokemon = filteredArrayOfPokemons[indexPath.row]
            performSegueWithIdentifier("SegueToDetailVC", sender: selectedPokemon)
        }else{
            let selectedPokemon = arrayOfPokemons[indexPath.row]
            performSegueWithIdentifier("SegueToDetailVC", sender: selectedPokemon)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "SegueToDetailVC"{
            
            if let detailVC = segue.destinationViewController as? PokemonDetailVC{
    
                if let senderPokemon = sender as? Pokemon{
                    detailVC.detailedPokemon = senderPokemon
                }
            }
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            userSearchingForPokemon = false
            
            collectionView.reloadData()
        
        }
            
        else{
            
            userSearchingForPokemon = true
            
            let searchString = searchBar.text?.lowercaseString
            
            filteredArrayOfPokemons = arrayOfPokemons.filter({$0.name.hasPrefix(searchString!) == true})
            
            collectionView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    
    

    
}
