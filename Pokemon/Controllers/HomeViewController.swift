//
//  ViewController.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- Properties
    let pokemonCellID = "PokemonIdentifier"
    var pokemons = [CustomPokemons]()
    var filteredPokemon = [CustomPokemons]()
    var inSearchMode = false
    var searchBar: UISearchBar!
    let refreshControl = UIRefreshControl()
    var isWaiting = false
    var offset = 20
    fileprivate let noInternetImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    fileprivate lazy var pokemonTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.register(PokemonCell.self, forCellReuseIdentifier: pokemonCellID)
        tableView.separatorColor = .darkGray
        return tableView
    }()
    
    //MARK:- App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkConnectivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        checkConnectivity()
    }
    
    private func configureUI(){
        renderPokemons()
        setupNavigationBar()
        configureNavigationBarButton()
        tableViewLayout()
        configurePullToRefresh()
        setupDelegates()
    }
    
    //MARK:- Check Connectivity
    private func checkConnectivity(){
        if NetworkMonitor.shared.isConnected != true{
            self.noInternetImageLayout()
        }else{
            self.noInternetImage.removeFromSuperview()
            self.configureUI()
        }
    }
    
    
    
    //MARK:- Delegates
    private func setupDelegates(){
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
    }
    
    //MARK:- UI Layouts
    private func noInternetImageLayout(){
        noInternetImage.frame = view.bounds
        noInternetImage.loadGif(name: "NoInternet")
        view.addSubview(noInternetImage)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Connection Lost"
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Pokemon"
    }
    
    private func tableViewLayout(){
        pokemonTableView.frame = self.view.bounds
        view.addSubview(pokemonTableView)
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .black
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func configureNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(handleSorting))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func configurePullToRefresh(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull me down")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        pokemonTableView.addSubview(refreshControl)
    }
    
    
    //MARK:- Handlers
    @objc func showSearchBar() {
        configureSearchBar()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        perform(#selector(refreshTableView), with: .none, afterDelay: 0.5)
    }
    
    @objc func refreshTableView(){
        pokemonTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func handleSorting(){
        let actionSheet = UIAlertController(title: "Sort Pokemons", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "A-Z ", style: .default, handler: { (handle) in
            self.sortAlphabetically()
        }))
        actionSheet.addAction(UIAlertAction(title: "1-N ", style: .default, handler: { (handle) in
            self.sortInAscendingOrder()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "N-1 ", style: .default, handler: { (handle) in
            self.sortInDescendingOrder()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK:- API Calls
    private func renderPokemons(){
        if let savedPokemons = UserDefaults.standard.object(forKey: Constants.pokemons) as? Data {
            let decoder = JSONDecoder()
            if let loadedPokemons = try? decoder.decode([CustomPokemons].self, from: savedPokemons) {
                self.pokemons = loadedPokemons
            }
        }else{
            fetchNewPokemons()
        }
    }
    
    
    private func fetchNewPokemons(){
        APIService.sharedInstance.fetchPokemons(offset: 0, completionHandler: { (poke) in
            self.pokemons = poke
            self.pokemonTableView.reloadData()
        })
    }
}
//MARK:- Helpers
extension HomeViewController{
    private func sortAlphabetically(){
        DispatchQueue.main.async {
            self.pokemons = self.pokemons.sorted { ($0.name?.lowercased())! < ($1.name?.lowercased())!}
            self.pokemonTableView.reloadData()
        }
    }
    
    private func sortInAscendingOrder(){
        DispatchQueue.main.async {
            self.pokemons = self.pokemons.sorted { ($0.id )! < ($1.id)!}
            self.pokemonTableView.reloadData()
        }
    }
    
    private func sortInDescendingOrder(){
        DispatchQueue.main.async {
            self.pokemons = self.pokemons.sorted { ($0.id )! > ($1.id)!}
            self.pokemonTableView.reloadData()
        }
    }
    
    func deleteDuplicates(array: [CustomPokemons]?) -> [CustomPokemons] {
        if var newArray = array{
            for i in 0 ..< newArray.count - 1  {
                for j in i + 1 ..< array!.count  {
                    if array?[i].id == array?[j].id {
                        newArray.remove(at: j)
                    }
                }
            }
            return newArray
        }else{
            return []
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configureNavigationBarButton()
        inSearchMode = false
        pokemonTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            pokemonTableView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon  = pokemons.filter({($0.name?.contains(searchText))!})
            self.pokemonTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }else{
            return pokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pokemonCellID, for: indexPath) as! PokemonCell
        cellBackgroundColor(cell: cell, row: indexPath.row)
        cell.selectionStyle = .none
        if inSearchMode{
            if let name = filteredPokemon[indexPath.row].name, let id = filteredPokemon[indexPath.row].id{
                cell.pokemonNumberLabel.text = "\(id)"
                cell.pokemonNameLabel.text = name
                cell.pokemonImage.loadImageUsingUrlString(urlString: "\(Constants.pokemonImageBaseURL)\(id).png")
                cell.fetchAbilities(pokemonCode: id)
            }
        }else{
            if let name = pokemons[indexPath.row].name, let id = pokemons[indexPath.row].id{
                cell.pokemonNumberLabel.text = "\(id)"
                cell.pokemonNameLabel.text = name
                cell.pokemonImage.loadImageUsingUrlString(urlString: "\(Constants.pokemonImageBaseURL)\(id).png")
                cell.fetchAbilities(pokemonCode: id)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PokemonCell{
            if let id = pokemons[indexPath.item].id, let name = pokemons[indexPath.item].name{
                let detailVC = PokemonDetailViewController()
                detailVC.pokemonID = id
                detailVC.backgroundView.backgroundColor = cell.backgroundColor
                detailVC.pokemonName.text = name
                detailVC.pokemonImage.loadImageUsingUrlString(urlString: "\(Constants.pokemonImageBaseURL)\(id).png")
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    private func cellBackgroundColor(cell: UITableViewCell, row: Int){
        if row % 4 == 0{
            cell.backgroundColor = UIColor.systemGreen
        }else if row % 3 == 0{
            cell.backgroundColor = UIColor.systemYellow
        }else if row % 2 == 0{
            cell.backgroundColor = UIColor.systemOrange
        }else{
            cell.backgroundColor = UIColor.systemPink
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (pokemonTableView.contentSize.height - 100 - scrollView.frame.size.height){
            self.pokemonTableView.tableFooterView = loadingSpinner()
            guard !APIService.sharedInstance.isPaginating else {return}
            if let savedPokemons = UserDefaults.standard.object(forKey: "\(Constants.pokemons)\(offset)") as? Data {
                let decoder = JSONDecoder()
                if let loadedPokemons = try? decoder.decode([CustomPokemons].self, from: savedPokemons) {
                    self.pokemons = loadedPokemons
                }
            }else{
                APIService.sharedInstance.fetchPokemons(pagination: true, offset: offset) { (pokemon) in
                    self.pokemons = pokemon
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(self.pokemons) {
                        let defaults = UserDefaults.standard
                        defaults.set(encoded, forKey: "\(Constants.pokemons)\(self.offset)")
                    }
                    self.pokemonTableView.reloadData()
                }
            }
            self.offset = self.offset + 20
        }
        self.pokemonTableView.tableFooterView = nil
    }
    
    private func loadingSpinner() -> UIView{
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: pokemonTableView.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.assignColor(UIColor.systemPink)
        spinner.center = footer.center
        footer.addSubview(spinner)
        spinner.startAnimating()
        return footer
    }
}

