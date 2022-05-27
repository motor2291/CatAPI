//
//  DetailViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/20.
//

import UIKit

class DetailViewController: UIViewController {

    var infoFromBreedURL: String?
    var infoFromBreedName: String?
    var infoFromBreedTemperament: String?
    var infoFromBreedDescription: String?
    var infoFromBreedHairless: Bool?
    var infoFromBreedEnergy: String = ""
    
    @IBOutlet weak var energyImage: UIImageView!
    @IBOutlet weak var breedDescription: UITextView!
    @IBOutlet weak var breedTemperament: UILabel!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var breedImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedName.text = infoFromBreedName
        breedTemperament.text = infoFromBreedTemperament
        energyImage.image = UIImage(systemName: infoFromBreedEnergy)
        if infoFromBreedHairless == true {
            breedDescription.text = infoFromBreedDescription?.appending("\n\nHairless")
        } else {
            breedDescription.text = infoFromBreedDescription
        }
        updateImage()
    }
    
    func updateImage() {
        if let imageURL = URL(string: infoFromBreedURL ?? "No Image") {
            do {
                let downloadImage = UIImage(data: try Data(contentsOf: imageURL))
                    self.breedImage.image = downloadImage
            } catch {
                print(error)
            }
        }
    }
}
