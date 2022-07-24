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
    var infoFromImageId: String?
    
    @IBOutlet weak var catImage: UIImageView!
    @IBAction func saveFavButton(_ sender: UIBarButtonItem) {
        saveFavData()
    }
    
    override func viewDidLoad() {
        updateImage()
    }
    
    func updateImage() {
        DispatchQueue.main.async {
            self.catImage.kf.setImage(with: self.infoFromImageURL)
        }
    }
    
    func saveFavData() {
        let loadedEmail = UserDefaults.standard.value(forKey: "userID")
        let json: [String: Any] = ["image_id": infoFromImageId!, "sub_id": loadedEmail!]
        let url = URL(string: "https://api.thecatapi.com/v1/favourites")!
        var request = URLRequest(url: url)
        request.setValue("3135a0e2-1fb4-4739-bac9-3cca33874ff0", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: [])
                print(response)
            } catch {
                    print(error)
                }
        }.resume()
        
        let controller = UIAlertController(title: title, message: "已加入我的最愛", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "太棒了", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}
