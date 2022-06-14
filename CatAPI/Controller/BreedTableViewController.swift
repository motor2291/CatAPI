//
//  BreedTableViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/20.
//

import UIKit
import Kingfisher

class BreedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var breedTableView: UITableView!
    var breeds = [BreedModel]()
    let baseURL = "https://api.thecatapi.com/v1/breeds"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breedTableView.delegate = self
        breedTableView.dataSource = self
        self.breedTableView.rowHeight = 100.0
        getBreedData()
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
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreedTableViewCell.self), for: indexPath) as! BreedTableViewCell
        let breed = breeds[indexPath.row]
        cell.breedName?.text = breed.name
        cell.breedTemperament?.text = breed.temperament
        cell.breedImageView.kf.setImage(with: breed.image?.url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let dvc = segue.destination as? DetailViewController {
                let selectedIndexPath = self.breedTableView.indexPathForSelectedRow
                if let selectedRow = selectedIndexPath?.row {
                    dvc.infoFromBreedURL = breeds[selectedRow].image?.url
                    dvc.infoFromBreedName = breeds[selectedRow].name
                    dvc.infoFromBreedTemperament = breeds[selectedRow].temperament
                    dvc.infoFromBreedDescription = breeds[selectedRow].breedExplaination
                    dvc.infoFromBreedHairless = breeds[selectedRow].isHairless
                    dvc.infoFromBreedEnergy = breeds[selectedRow].energyLevel
                    dvc.infoFromBreedAdaptability = breeds[selectedRow].adaptability
                    dvc.infoFromBreedChildFriendly = breeds[selectedRow].childFriendly
                    dvc.infoFromBreedDogFriendly = breeds[selectedRow].dogFriendly
                    dvc.infoFromBreedIntelligence = breeds[selectedRow].intelligence
                    dvc.infoFromBreedHealthIssues = breeds[selectedRow].healthIssues
                    dvc.infoFromBreedStrangerFriendly = breeds[selectedRow].strangerFriendly
                    dvc.infoFromBreedWikipediaUrl = breeds[selectedRow].wikipediaUrl
                }
            }
        }
    }
}
