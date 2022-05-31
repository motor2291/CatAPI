//
//  VoteViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/16.
//

import UIKit
import Kingfisher

class VoteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBAction func likeButton(_ sender: UIButton) {
        voteManager.performSaveFav()
    }
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        voteManager.performRequest()
    }
    @IBAction func dislikeButton(_ sender: UIButton) {
        voteManager.performRequest()
    }
    
    var voteManager = VoteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voteManager.delegate = self
        voteManager.performRequest()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "Vote your favorite"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}

//MARK: - VoteManageDelegate

extension VoteViewController: VoteManagerDelegate {
  
    func didUpdataImage(vote: VoteModel) {
            DispatchQueue.main.async {
                self.catImage.kf.setImage(with: vote.url)
            }
        }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func saveFavData(vote: VoteModel) {
        let json: [String: Any] = ["image_id": vote.id]
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




