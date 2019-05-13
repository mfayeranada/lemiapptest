//
//  CityTableViewCell.swift
//  LemiAppTest
//
//  Created by Meredith Faye Ranada on 11/05/2019.
//  Copyright © 2019 Meredith Faye Ranada. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var citySubtitleLbl: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityImageView.layer.cornerRadius = cityImageView.frame.height/2
        cityImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
