//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//

import UIKit
class PokemonDetailViewController: UIViewController {
    //MARK:- Properties
    var pokemonID: Int?
    var abilities: Abilities?
    let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var pokemonImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .none
        return image
    }()
    
    let pokemonName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let abilityHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.text = "Abilities"
        return label
    }()
    
    fileprivate let abilityTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.rowHeight = 40
        tableView.backgroundColor = .clear
        tableView.register(AbilityCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK:- App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        view.backgroundColor = .white
        fetchAbilities()
        pokemonImageLayout()
        pokemonNameLabelLayout()
        abilitiesHeaderLayout()
        tableViewLayout()
        setupDelegates()
    }
    
    //MARK:- UI Layout
    
    private func setupDelegates(){
        abilityTableView.delegate = self
        abilityTableView.dataSource = self
    }
    
    private func pokemonImageLayout(){
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: (view.frame.size.height / 2) + 50)
        view.addSubview(backgroundView)
        pokemonImage.frame = backgroundView.bounds
        backgroundView.addSubview(pokemonImage)
    }
    
    private func pokemonNameLabelLayout(){
        view.addSubview(pokemonName)
        pokemonName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pokemonName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        pokemonName.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 5).isActive = true
    }
    
    private func abilitiesHeaderLayout(){
        view.addSubview(abilityHeaderLabel)
        abilityHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        abilityHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        abilityHeaderLabel.topAnchor.constraint(equalTo: pokemonName.bottomAnchor, constant: 20).isActive = true
    }
    
    private func tableViewLayout(){
        view.addSubview(abilityTableView)
        abilityTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        abilityTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        abilityTableView.topAnchor.constraint(equalTo: abilityHeaderLabel.bottomAnchor, constant: 10).isActive = true
        abilityTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK:- API Calls
    
    private func fetchAbilities(){
        if let pokemonID = pokemonID{
            APIService.sharedInstance.fetchAbilities(pokemonCode: pokemonID) { (ability) in
                self.abilities = ability
                self.abilityTableView.reloadData()
            }
        }
    }
}
extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = abilities?.abilities?.count{
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AbilityCell
        if let abilities = abilities?.abilities?[indexPath.row].ability?.name{
            cell.abilityLabel.text = "\(indexPath.row + 1).  \(abilities.capitalized)"
        }
        return cell
    }
    
}
