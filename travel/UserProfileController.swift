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
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail?.text = mail
        userName?.text = user
       // ref = FIRDatabase.database().reference().child("USERS").child(self.userUid).child("INTERESTS")
        
    }
    
    @IBAction func chooseFestival(_ sender: Any) {
        ref.updateChildValues(["Festival":1,])
    }
    
    @IBAction func chooseAdventure(_ sender: Any) {
        ref.updateChildValues(["Adventure":1])
    }
    @IBAction func chooseRomance(_ sender: Any) {
        ref.updateChildValues(["Romance":1])
    }
    
    @IBAction func chooseMountain(_ sender: Any) {
        ref.updateChildValues(["Nature":1])  ///// NATURE?
    }
    
    @IBAction func chooseNightlife(_ sender: Any) {
        ref.updateChildValues(["Night Life":1])
    }
    
    @IBAction func chooseBeach(_ sender: Any) {
        ref.updateChildValues(["Beach":1])
    }
    @IBAction func chooseFoodAndDrink(_ sender: Any) {
        ref.updateChildValues(["Food and Drink":1])
    }
    @IBAction func chooseWarmWeather(_ sender: Any) {
        ref.updateChildValues(["Warm Weather":1])
    }
    
    @IBAction func chooseSafety(_ sender: Any) {
        ref.updateChildValues(["Safety":1])
    }
    
    @IBAction func chooseRoadtrip(_ sender: Any) {
        ref.updateChildValues(["RoadTrip":1])
    }
    
    
    
    
    
    
}
