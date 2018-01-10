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
import FirebaseStorage
import Kingfisher

class UserProfileController: UIViewController,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    var mail : String!
    var user: String!
    var userUid : String!
    var ref : DatabaseReference!
    var imageRef : DatabaseReference!

    var storageRef : StorageReference!
    let picker = UIImagePickerController()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
   
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
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        profilePicView.layer.cornerRadius = (self.profilePicView.frame.width)/1.5
        profilePicView.layer.masksToBounds = true
        
        picker.delegate = self
        ref = Database.database().reference().child("USERS").child(self.userUid).child("INTERESTS")
                storageRef = Storage.storage().reference().child("userImages/\(self.userUid!).jpg")
        self.imageRef = Database.database().reference().child("USERS").child(self.userUid)

        imageRef.observeSingleEvent(of: .value,with : { (snapshot) in
            if (snapshot.hasChild("UserPhoto")){
                self.storageRef.getData(maxSize: 10*1024*1024, completion: { (data, error) in
                    let userPhoto = UIImage(data: data!)
                    self.profilePicView.image = userPhoto
                    self.profilePicView.layer.borderWidth = 3
                    self.profilePicView.layer.borderColor = UIColor.blue.cgColor
                    self.activityIndicator.stopAnimating()
                })
            }
            else{
            self.profilePicView.image = #imageLiteral(resourceName: "profileIcon")
            self.activityIndicator.stopAnimating()
            }
        })
        //ref.updateChildValues(["RoadTrip":1])
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profilePicView.contentMode = .scaleAspectFit //3
        profilePicView.image = chosenImage //4
        var data = Data()
        data = UIImageJPEGRepresentation(chosenImage, 1.0)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(data, metadata:metaData){ (metaData, error) in
            if let error = error{
                print("error")
                return
            }else{
                let imageUrl = metaData!.downloadURL()!.absoluteString
                self.imageRef.updateChildValues(["UserPhoto": imageUrl])

            }
        }
        
        dismiss(animated:true, completion: nil) //5    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    
    
    }
    
}
