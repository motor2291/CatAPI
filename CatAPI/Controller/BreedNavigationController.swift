//
//  BreedNavigationController.swift
//  CatAPI
//
//  Created by motor on 2022/7/23.
//

import UIKit

class BreedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }

}
