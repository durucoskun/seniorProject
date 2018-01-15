//
//  InterestData.swift
//  travel
//
//  Created by Duru Coskun on 14/01/2018.
//  Copyright © 2018 Ata Aygen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class InterestData{
    
    var userUid : String
    var interestDictionary : [String : Int] = [:]
    var interestRef : DatabaseReference!
    init(userUid : String){
        self.userUid = userUid
        getInterestScores(userUid: userUid)
    }
    func getInterestScores(userUid : String){
       self.interestRef = Database.database().reference().child("USERS").child(self.userUid).child("INTERESTS")
        self.interestRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
        self.interestDictionary = (snapshot.value)! as! [String : Int]
            print(self.interestDictionary)
        })
    }
    
}
