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
import FirebaseAuth

class UserProfileController: UIViewController,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    var mail : String!
    var user: String!
    var userUid : String!
    var ref : DatabaseReference!
    let picker = UIImagePickerController()
   
    @IBOutlet weak var profilePicView: UIImageView!
   
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logout", sender: Any?.self)
    }
    
    @IBAction func changePic(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
       ref = Database.database().reference().child("USERS").child(self.userUid).child("INTERESTS")
        //ref.updateChildValues(["RoadTrip":1])
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profilePicView.contentMode = .scaleAspectFit //3
        profilePicView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    
    
    }
    
}
