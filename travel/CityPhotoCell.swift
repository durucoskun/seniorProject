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
    
    var cityImageView : UIImageView!
    
    override func awakeFromNib() {
        cityImageView = UIImageView(frame : contentView.frame)
   cityImageView?.contentMode = .scaleAspectFill
        cityImageView?.clipsToBounds=true
        contentView.addSubview(cityImageView)
    }
    

}
