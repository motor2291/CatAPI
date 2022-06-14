//
//  DetailViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/20.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var infoFromBreedURL: URL?
    var infoFromBreedName: String?
    var infoFromBreedTemperament: String?
    var infoFromBreedDescription: String?
    var infoFromBreedHairless: Bool?
    var infoFromBreedEnergy: Double?
    var infoFromBreedAdaptability: Double?
    var infoFromBreedChildFriendly: Double?
    var infoFromBreedDogFriendly: Double?
    var infoFromBreedIntelligence: Double?
    var infoFromBreedHealthIssues: Double?
    var infoFromBreedStrangerFriendly: Double?
    var infoFromBreedWikipediaUrl: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var breedImage: UIImageView!
    @IBAction func wikiLinkButton(_ sender: UIButton) {
        guard let safeURL = infoFromBreedWikipediaUrl, safeURL != "" else {
            print("infoFromBreedWikipediaUrl is nil.")
            return
        }
        
        if let url = URL(string: safeURL) {
            UIApplication.shared.open(url)
        } else {
            print("Website URL is not correct")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        if infoFromBreedHairless == true {
//            breedDescription.text = infoFromBreedDescription?.appending("\n\nHairless")
//        } else {
//            breedDescription.text = infoFromBreedDescription
//        }
        breedImage.kf.setImage(with: infoFromBreedURL)
    }
    
    //MARK: - UITableView Methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BreedNameCell", for: indexPath)
            cell.textLabel?.text = infoFromBreedName
            cell.detailTextLabel?.text = infoFromBreedTemperament
            return cell
            
        } else if indexPath.row <= 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BreedDescriptionCell", for: indexPath)
            cell.textLabel?.text = infoFromBreedDescription
            return cell
           
        } else if indexPath.row <= 8 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreedDetailRatingCell.self), for: indexPath) as! BreedDetailRatingCell
            
            switch indexPath.row {
                
            case 2:
                cell.ratingStars.rating = infoFromBreedEnergy!
                cell.itemLabel.text = "Energy Level"
                return cell
                
            case 3:
                cell.ratingStars.rating = infoFromBreedAdaptability!
                cell.itemLabel.text = "Adaptability"
                return cell
                
            case 4:
                cell.ratingStars.rating = infoFromBreedChildFriendly!
                cell.itemLabel.text = "Child Friendly"
                return cell
                
            case 5:
                cell.ratingStars.rating = infoFromBreedDogFriendly!
                cell.itemLabel.text = "Dog Friendly"
                return cell
                
            case 6:
                cell.ratingStars.rating = infoFromBreedIntelligence!
                cell.itemLabel.text = "Intelligence"
                return cell
                
            case 7:
                cell.ratingStars.rating = infoFromBreedHealthIssues!
                cell.itemLabel.text = "Health Issues"
                return cell
                
            case 8:
                cell.ratingStars.rating = infoFromBreedStrangerFriendly!
                cell.itemLabel.text = "Stranger Friendly"
                return cell
                
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            }
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HyperLinkCell.self), for: indexPath) as! HyperLinkCell
            return cell
        }
    }
}
