//
//  TabBarViewController.swift
//  CatAPI
//
//  Created by motor on 2022/7/21.
//

import UIKit
import Firebase
import SideMenu

class TabBarViewController: UITabBarController, MenuTableVCDelegate {
    
    private var sideMenu: SideMenuNavigationController?
    private let infoController = InfoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuTableVC(with: SideMenuItem.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        //addChildController()
    }
    
    @IBAction func didTapMenuBtn(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            UserDefaults.standard.removeObject(forKey: "userID")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        
        switch named {
        case .logOut:
            infoController.view.isHidden = true
            do {
                try Auth.auth().signOut()
                navigationController?.popToRootViewController(animated: true)
                UserDefaults.standard.removeObject(forKey: "userID")
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        case .theCatAPI:
            if let url = URL(string: "https://thecatapi.com/") {
                UIApplication.shared.open(url)
            } else {
                print("Website URL is not correct")
            }
        case .privacyPolicy:
            if let url = URL(string: "https://motorapp.mobirisesite.com/") {
                UIApplication.shared.open(url)
            } else {
                print("Website URL is not correct")
            }
        }
    }
    
    private func addChildController() {
        addChild(infoController)
        view.addSubview(infoController.view)
        infoController.view.frame = view.bounds
        infoController.didMove(toParent: self)
        infoController.view.isHidden = true
    }

}
