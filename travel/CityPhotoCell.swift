//
//  CityPhotoCell.swift
//  travel
//
//  Created by Duru Coskun on 02/12/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//


import UIKit

class CityPhotoCell : UICollectionViewCell{
    
  
   // @IBOutlet weak var cityImageView: UIImageView!
    
    var cityNameLabel : UILabel?
    override func awakeFromNib() {
        cityNameLabel = UILabel(frame : contentView.frame)
   cityNameLabel?.contentMode = .scaleAspectFill
        cityNameLabel?.clipsToBounds=true
        contentView.addSubview(cityNameLabel!)
    }
    

}
