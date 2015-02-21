//
//  ViewController.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        let tag = ["Albanie", "Allemagne", "Andorre", "Autriche-Hongrie", "Belgique", "Bulgarie", "Danemark", "Espagne", "France", "Grèce", "Italie", "Liechtenstein", "Luxembourg", "Monaco", "Monténégro", "Norvège", "Pays-Bas", "Portugal", "Roumanie", "Royaume-Uni", "Russie", "Saint-Marin", "Serbie", "Suède", "Suisse"]
        
        RRTagController.displayTagController(parentController: self, tagsString: tag, blockFinish: { (selectedTags, unSelectedTags) -> () in
        }) { () -> () in
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

