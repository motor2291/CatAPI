//
//  VoteViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/16.
//

import UIKit
import Kingfisher
import SideMenu
import Firebase

class VoteViewController: UIViewController {
    
    var voteModel = [VoteModel]()
    let baseURL = "https://api.thecatapi.com/v1/images/search"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImageData()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "🐈點選喜歡加入您的最愛🐆"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBAction func likeButton(_ sender: UIButton) {
        saveFavData()
        getImageData()
    }
    @IBAction func dislikeButton(_ sender: UIButton) {
        getImageData()
    }
    
    func getImageData() {
        
        let urlString = "\(baseURL)?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                do {
                    let votes = try JSONDecoder().decode([VoteModel].self, from: safeData)
                    self.voteModel = votes
                    DispatchQueue.main.async {
                        self.catImage.kf.setImage(with: votes[0].url)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func saveFavData() {
        let loadedEmail = UserDefaults.standard.value(forKey: "userID")!
        let json: [String: Any] = ["image_id": voteModel[0].id, "sub_id": loadedEmail]
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
    }

}
