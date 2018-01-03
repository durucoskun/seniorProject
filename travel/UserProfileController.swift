//
//  UserProfileController.swift
//  travel
//
//  Created by Duru Coskun on 26/11/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class UserProfileController: UIViewController{
    
    var mail : String!
    var user: String!
    var userUid : String!
    var ref : DatabaseReference!
   
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var message: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        message.layer.masksToBounds = true
        message.layer.cornerRadius = 8.0
       // ref = FIRDatabase.database().reference().child("USERS").child(self.userUid).child("INTERESTS")
        
    }
    @IBAction func chooseRoadtrip(_ sender: Any) {
        ref.updateChildValues(["RoadTrip":1])
    }
    
    
    
    
    
    
}
