//
//  TabBarViewController.swift
//  CatAPI
//
//  Created by motor on 2022/7/21.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        //navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

}
