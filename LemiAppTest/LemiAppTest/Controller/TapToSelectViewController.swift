//
//  TapToSelectViewController.swift
//  LemiAppTest
//
//  Created by Meredith Faye Ranada on 11/05/2019.
//  Copyright © 2019 Meredith Faye Ranada. All rights reserved.
//

import UIKit

class TapToSelectViewController: UIViewController {
    
    @IBOutlet weak var tapToSelectView: UIStackView!
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var valuePassedLbl: UILabel!
    var valueToPass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchIconImageView.image = UIImage(named: "SearchIcon")
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchCity(gestureRecognizer:)))
        tapToSelectView.gestureRecognizerShouldBegin(tap)
        valuePassedLbl.text = valueToPass
    }
    
    @IBAction func searchCity(gestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "SearchCityView", sender: self)
    }
    
}
