//
//  MainViewController.swift
//  PokeDex
//
//  Created by Diparth Patel on 6/26/17.
//  Copyright © 2017 Diparth Patel. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var myDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        parsePokemonCSVFile()
        
        initAudio()
        
        fetchAndPrintData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchAndPrintData() {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            print(dict)
            
        }
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer.init(contentsOf: URL.init(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            if myDefaults.value(forKey: "IsMusicPlaying") != nil {
                if myDefaults.bool(forKey: "IsMusicPlaying") {
                    musicPlayer.play()
                }else {
                    musicPlayer.pause()
                }
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func parsePokemonCSVFile() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV.init(contentsOfURL: path!)
            let rows = csv.rows
            //print("\(rows)")
            for row in rows {
                let id = Int(row["id"]!)!
                let name = row["identifier"]!
                pokemons.append(Pokemon.init(name: name, ID: id))
            }
        }catch {
            print("Error: \(error)")
        }
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
            myDefaults.set(false, forKey: "IsMusicPlaying")
            myDefaults.synchronize()
        }else {
            musicPlayer.play()
            sender.alpha = 1.0
            myDefaults.set(true, forKey: "IsMusicPlaying")
            myDefaults.synchronize()
        }
        
    }
    
    

}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemons.filter({$0.name.range(of: lower) != nil})
            collectionView.reloadData()
        }
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }else {
            return pokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PokeCell {
            let pokemon: Pokemon!
            
            if inSearchMode {
                pokemon = filteredPokemon[indexPath.row]
            }else {
                pokemon = pokemons[indexPath.row]
            }
            
            cell.configureCell(pokemon: pokemon)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon: Pokemon!
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row]
        }else {
            pokemon = pokemons[indexPath.row]
        }
        pokemon.description
        performSegue(withIdentifier: "detailView", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PokemonDetailVC {
            if let poke = sender as? Pokemon {
                viewController.pokemon = poke
            }
        }
    }
    
}










