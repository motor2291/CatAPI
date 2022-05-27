//
//  DetailImageViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/26.
//

import UIKit
import Kingfisher

class DetailImageViewController: UIViewController {
    
    var infoFromImageURL: URL?
    
    @IBOutlet weak var catImage: UIImageView!
    
    override func viewDidLoad() {
        updateImage()
    }
    
    func updateImage() {
        DispatchQueue.main.async {
            self.catImage.kf.setImage(with: self.infoFromImageURL)
        }
    }
}
