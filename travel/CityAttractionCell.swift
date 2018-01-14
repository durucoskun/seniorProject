//
//  CityAttractionCell.swift
//  travel
//
//  Created by Duru Coskun on 03/01/2018.
//  Copyright © 2018 Ata Aygen. All rights reserved.
//

import UIKit

class CityAttractionCell: UITableViewCell {
    
    
    @IBOutlet weak var descriptionText: UITextView!
        @IBOutlet weak var attractionName: UILabel!
    @IBOutlet weak var attractionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
