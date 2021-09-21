//
//  ViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 20/09/21.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          
    }
    //Oculta barra de navegação
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

}

