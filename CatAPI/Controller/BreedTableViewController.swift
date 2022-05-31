//
//  BreedTableViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/20.
//

import UIKit
import Kingfisher

class BreedTableViewController: UITableViewController {
    
    var breeds = [BreedModel]()
    let baseURL = "https://api.thecatapi.com/v1/breeds"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    
    func getBreedData() {
        
        let urlString = "\(baseURL)?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                do {
                    let breeds = try JSONDecoder().decode([BreedModel].self, from: safeData)
                    self.breeds = breeds
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBreedData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breedCell", for: indexPath)
        
        let breed = breeds[indexPath.row]
        cell.textLabel?.text = breed.name
        cell.detailTextLabel?.text = breed.temperament
        
        if let imageURL = URL(string: breed.image?.url ?? "No Image") {
            do {
                let downloadImage = UIImage(data: try Data(contentsOf: imageURL))!
                cell.imageView?.image = imageWithImage(image: downloadImage , scaledToSize: CGSize(width: 100, height: 100))
                //cell.imageView?.kf.setImage(with: imageURL)
            } catch {
                print(error)
            }
        }
        return cell
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let dvc = segue.destination as? DetailViewController {
                let selectedIndexPath = self.tableView.indexPathForSelectedRow
                if let selectedRow = selectedIndexPath?.row {
                    dvc.infoFromBreedURL = breeds[selectedRow].image?.url
                    dvc.infoFromBreedName = breeds[selectedRow].name
                    dvc.infoFromBreedTemperament = breeds[selectedRow].temperament
                    dvc.infoFromBreedDescription = breeds[selectedRow].breedExplaination
                    dvc.infoFromBreedHairless = breeds[selectedRow].isHairless
                    dvc.infoFromBreedEnergy = breeds[selectedRow].energyImage
                }
            }
        }
    }
    
}
