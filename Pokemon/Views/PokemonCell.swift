//
//  PokemonCell.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//
import UIKit
class PokemonCell: UITableViewCell {
    var pokemonAbility: Abilities?{
        didSet{
            if let ability = pokemonAbility?.abilities?[0].ability?.name{
                self.abilityLabel.text = ability.capitalized
            }
        }
    }
    let pokemonNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "01"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.text = "Pokemon"
        return label
    }()
    
    fileprivate let abilitiesHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Master Ability"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let abilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    fileprivate let pokeballImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "pokeball"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.alpha = 0.4
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let pokemonImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    private func configureUI(){
        pokeballImageLayout()
        pokemonNumberLabelLayout()
        pokemonImageLayout()
        pokemonNameLabelLayout()
        abilitiesLabelLayout()
        abilityLabelLayout()
    }
    
    private func pokemonImageLayout(){
        addSubview(pokemonImage)
        pokemonImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        pokemonImage.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
        pokemonImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        pokemonImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    private func pokeballImageLayout(){
        addSubview(pokeballImage)
        pokeballImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pokeballImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pokeballImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pokeballImage.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
    }
    
    private func abilityLabelLayout(){
        addSubview(abilityLabel)
        abilityLabel.leadingAnchor.constraint(equalTo: pokemonNameLabel.leadingAnchor).isActive = true
        abilityLabel.topAnchor.constraint(equalTo: abilitiesHeaderLabel.bottomAnchor, constant: 5).isActive = true
        abilityLabel.trailingAnchor.constraint(equalTo: pokemonNameLabel.trailingAnchor).isActive = true
    }
    
    private func abilitiesLabelLayout(){
        addSubview(abilitiesHeaderLabel)
        abilitiesHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        abilitiesHeaderLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        abilitiesHeaderLabel.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    private func pokemonNameLabelLayout(){
        addSubview(pokemonNameLabel)
        pokemonNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        pokemonNameLabel.trailingAnchor.constraint(equalTo: pokemonImage.leadingAnchor, constant: -10).isActive = true
        pokemonNameLabel.topAnchor.constraint(equalTo: pokemonNumberLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    private func pokemonNumberLabelLayout(){
        addSubview(pokemonNumberLabel)
        pokemonNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        pokemonNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        pokemonNumberLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func fetchAbilities(pokemonCode: Int){
        APIService.sharedInstance.fetchAbilities(pokemonCode: pokemonCode) { (ability) in
            self.pokemonAbility = ability
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
