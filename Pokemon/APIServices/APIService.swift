//
//  APIService.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//

import UIKit
class APIService: NSObject {
    static let sharedInstance = APIService()
    var isPaginating = false
    var pokemonsArr = [CustomPokemons]()
    var pokemonID = 1
    
    func fetchPokemons(pagination: Bool = false, offset: Int = 0, completionHandler: @escaping ([CustomPokemons]) -> Void){
        let urlString = "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=20"
        guard let safeURL = URL(string: urlString) else {return}
        if pagination{
            isPaginating = true
        }
        URLSession.shared.dataTask(with: safeURL) { data, response, err in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            do{
                let jsonData = try JSONDecoder().decode(Pokemons.self, from: safeData)
                DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 1 : 0)) {
                    DispatchQueue.main.async { [self] in
                        if let fetchedPokemons = jsonData.results{
                            for pokemon in fetchedPokemons{
                                let poke = CustomPokemons(name: pokemon.name?.capitalized, image: pokemon.url, id: pokemonID)
                                pokemonID += 1
                                self.pokemonsArr.append(poke)
                            }
                        }
                        let encoder = JSONEncoder()
                        if let encoded = try? encoder.encode(self.pokemonsArr) {
                            let defaults = UserDefaults.standard
                            defaults.set(encoded, forKey: "\(Constants.pokemons)\(offset)")
                        }
                        completionHandler(self.pokemonsArr)
                        if pagination{
                            self.isPaginating = false
                        }
                    }
                }}catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    return
                }
        }.resume()
    }
    
    func fetchAbilities(pokemonCode: Int, completionHandler: @escaping (Abilities) -> Void){
        let urlString = "\(Constants.abilities_Base_URL)\(pokemonCode)"
        guard let safeURL = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: safeURL) { data, response, err in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            do{
                let jsonData = try JSONDecoder().decode(Abilities.self, from: safeData)
                DispatchQueue.main.async {
                    completionHandler(jsonData)
                }
            }catch let jsonErr{
                print(jsonErr.localizedDescription)
                return
            }
        }.resume()
    }
}
