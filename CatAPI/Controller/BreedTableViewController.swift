//
//  BreedTableViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/20.
//

import UIKit
import Kingfisher

class BreedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var breedTableView: UITableView!
    
    var breeds = [BreedModel]()
    var searchResults: [BreedModel] = []
    var searching = false
    let baseURL = "https://api.thecatapi.com/v1/breeds"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBreedData()
        searchBar.delegate = self
        breedTableView.delegate = self
        breedTableView.dataSource = self
        self.breedTableView.rowHeight = 100.0
        
    }
    
    func getBreedData() {
        
        let urlString = "\(baseURL)?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                do {
                    let breeds = try JSONDecoder().decode([BreedModel].self, from: safeData)
                    self.breeds = breeds
                    DispatchQueue.main.async {
                        self.breedTableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchResults.count
        } else {
            return breeds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreedTableViewCell.self), for: indexPath) as! BreedTableViewCell
        let breed = (searching) ? searchResults[indexPath.row] : breeds[indexPath.row]
        cell.breedName?.text = breed.name
        cell.breedTemperament?.text = breed.temperament
        cell.breedImageView.kf.setImage(with: breed.image?.url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let dvc = segue.destination as? DetailViewController {
                let selectedIndexPath = self.breedTableView.indexPathForSelectedRow
                if let selectedRow = selectedIndexPath?.row {
                    dvc.infoFromBreedURL = (searching) ? searchResults[selectedRow].image?.url : breeds[selectedRow].image?.url
                    dvc.infoFromBreedName = (searching) ? searchResults[selectedRow].name : breeds[selectedRow].name
                    dvc.infoFromBreedTemperament = (searching) ? searchResults[selectedRow].temperament : breeds[selectedRow].temperament
                    dvc.infoFromBreedDescription = (searching) ? searchResults[selectedRow].breedExplaination : breeds[selectedRow].breedExplaination
                    dvc.infoFromBreedHairless = (searching) ? searchResults[selectedRow].isHairless : breeds[selectedRow].isHairless
                    dvc.infoFromBreedEnergy = (searching) ? searchResults[selectedRow].energyLevel : breeds[selectedRow].energyLevel
                    dvc.infoFromBreedAdaptability = (searching) ? searchResults[selectedRow].childFriendly : breeds[selectedRow].adaptability
                    dvc.infoFromBreedChildFriendly = (searching) ? searchResults[selectedRow].childFriendly : breeds[selectedRow].childFriendly
                    dvc.infoFromBreedDogFriendly = (searching) ? searchResults[selectedRow].dogFriendly : breeds[selectedRow].dogFriendly
                    dvc.infoFromBreedIntelligence = (searching) ? searchResults[selectedRow].intelligence : breeds[selectedRow].intelligence
                    dvc.infoFromBreedHealthIssues = (searching) ? searchResults[selectedRow].healthIssues : breeds[selectedRow].healthIssues
                    dvc.infoFromBreedStrangerFriendly = (searching) ? searchResults[selectedRow].strangerFriendly : breeds[selectedRow].strangerFriendly
                    dvc.infoFromBreedWikipediaUrl = (searching) ? searchResults[selectedRow].wikipediaUrl : breeds[selectedRow].wikipediaUrl
                }
            }
        }
    }
}

extension BreedTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = breeds.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        if(searchResults.count == 0){
            searching = false;
        } else {
            searching = true;
        }
        breedTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        breedTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        breedTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
