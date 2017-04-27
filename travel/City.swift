//
//  City.swift
//  travel
//
//  Created by Ata Aygen on 13/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit

class City: NSObject {
    let name: String
    let lowestPrice: Int
    
    init (name: String, lowestPrice: Int){
        self.name = name
        self.lowestPrice = lowestPrice
    }
    
}
