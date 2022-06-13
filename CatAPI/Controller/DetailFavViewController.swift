//
//  DetailFavViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/31.
//
import Kingfisher
import UIKit

class DetailFavViewController: UIViewController {
    
    @IBOutlet weak var favImageView: UIImageView!
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        deleteFavData()
        self.navigationController?.popViewController(animated: true)
    }
    
    var infoFromImageURL: URL?
    var infoFromImageId: Int?
    
    override func viewDidLoad() {
        updateImage()
    }
    
    func updateImage() {
        DispatchQueue.main.async {
            self.favImageView.kf.setImage(with: self.infoFromImageURL)
        }
    }
    
    func deleteFavData() {
        let url = URL(string: "https://api.thecatapi.com/v1/favourites/\(infoFromImageId ?? 666)")!
        var request = URLRequest(url: url)
        request.setValue("3135a0e2-1fb4-4739-bac9-3cca33874ff0", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "DELETE"

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
    }
}
