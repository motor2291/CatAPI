//
//  VoteViewController.swift
//  CatAPI
//
//  Created by motor on 2022/5/16.
//

import UIKit
import Kingfisher
import SideMenu

class VoteViewController: UIViewController, MenuTableVCDelegate {
    
    var voteManager = VoteManager()
    private var sideMenu: SideMenuNavigationController?
    private let settingsController = SettingsViewController()
    private let infoController = InfoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuTableVC(with: SideMenuItem.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        voteManager.delegate = self
        voteManager.performRequest()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "點選喜歡加入您的最愛"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        addChildController()
    }

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
    @IBAction func didTapMenuBtn(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        
        switch named {
        case .home:
            settingsController.view.isHidden = true
            infoController.view.isHidden = true
        case .info:
            settingsController.view.isHidden = true
            infoController.view.isHidden = false
        case .settings:
            settingsController.view.isHidden = false
            infoController.view.isHidden = true
        }
    }
    
    private func addChildController() {
        addChild(settingsController)
        addChild(infoController)
        
        view.addSubview(settingsController.view)
        view.addSubview(infoController.view)
        settingsController.view.frame = view.bounds
        infoController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        infoController.didMove(toParent: self)
        
        settingsController.view.isHidden = true
        infoController.view.isHidden = true
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




