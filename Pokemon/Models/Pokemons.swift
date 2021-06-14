//
//  Pokemons.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//

import UIKit
struct Pokemons: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonResults]?
}

// MARK: - Result
struct PokemonResults: Codable {
    let name: String?
    let url: String?
}

// MARK: - Abilities
struct Abilities: Codable {
    let abilities: [Ability]?
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Species?
}

// MARK: - Species
struct Species: Codable {
    let name: String?
    let url: String?
}
