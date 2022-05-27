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
        voteManager.fetchCatData()
    }
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        voteManager.fetchCatData()
    }
    @IBAction func dislikeButton(_ sender: UIButton) {
        voteManager.fetchCatData()
    }
    
    var voteManager = VoteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voteManager.delegate = self
        voteManager.fetchCatData()
        
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
}




