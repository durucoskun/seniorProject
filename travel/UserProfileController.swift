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
    var interestDictionary : [String : Int] = [:]
    var storageRef : StorageReference!
    let picker = UIImagePickerController()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var overlayView: UIView = UIView()

    @IBOutlet weak var profilePicView: UIImageView!
    var interestRef : DatabaseReference!
    @IBOutlet weak var safetyButton: UIButton!
    @IBOutlet weak var nightLifeButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var festivalButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var cultureButton: UIButton!
    @IBOutlet weak var architectureButton: UIButton!
    @IBOutlet weak var artButton: UIButton!
    
    @IBOutlet weak var sightseeingButton: UIButton!
    var activityIndicatorView : UIActivityIndicatorView = UIActivityIndicatorView()
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
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5);
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        overlayView.addSubview(activityIndicatorView)
activityIndicatorView.startAnimating()
        view.addSubview(overlayView)
        overlayView.isHidden = false
        //
        interestRef = Database.database().reference()
        let interestData = InterestData(userUid: userUid)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {

        self.interestDictionary = interestData.interestDictionary
            if !(self.interestDictionary == nil){
                self.activityIndicatorView.stopAnimating()
                self.overlayView.isHidden = true

        self.setButtons()
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.profilePicView.layer.cornerRadius = (self.profilePicView.frame.width)/2
        self.profilePicView.layer.masksToBounds = true
        
        self.picker.delegate = self
        self.ref = Database.database().reference().child("USERS").child(self.userUid).child("INTERESTS")
               self.storageRef = Storage.storage().reference().child("userImages/\(self.userUid!).jpg")
        self.imageRef = Database.database().reference().child("USERS").child(self.userUid)

        self.imageRef.observeSingleEvent(of: .value,with : { (snapshot) in
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
            }  })
        
        
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
    func setInterestButton(button : UIButton , tag : String){
         button.setTitleColor(UIColor.black,for: UIControlState.normal)
        button.frame.size.height = 85
        button.frame.size.width = 30
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        if (interestDictionary[tag] != nil){
        if interestDictionary[tag] as! Int == 1{
            button.setTitleColor(UIColor.white,for: UIControlState.normal)
            button.backgroundColor = UIColor.purple

        }else if interestDictionary[tag] as! Int == 0{
            button.backgroundColor = UIColor.lightGray
            
        }
        }
    }
    func setButtons(){
      
        setInterestButton(button : safetyButton, tag: "Safety")
        setInterestButton(button : artButton,tag:"Art")
        setInterestButton(button : architectureButton,tag:"Architecture")
        setInterestButton(button : sightseeingButton,tag:"Sightseeing")
        setInterestButton(button : cultureButton,tag:"Culture")
        setInterestButton(button : historyButton,tag:"History")
        setInterestButton(button : shoppingButton,tag:"Shopping")
        setInterestButton(button : foodButton,tag:"Food")
        setInterestButton(button : festivalButton,tag:"Festivals")
        setInterestButton(button : nightLifeButton,tag:"Nightlife")

    }

   
    @IBAction func preferSafety(_ sender: Any) {
        setInterest(button:safetyButton,tag:"Safety")

        
    }
    @IBAction func preferNightlife(_ sender: Any) {
        setInterest(button:nightLifeButton,tag:"Nightlife")

        
    }
    @IBAction func preferShopping(_ sender: Any) {
        setInterest(button: shoppingButton,tag: "Shopping")


    }
    @IBAction func preferFestival(_ sender: Any) {
        setInterest(button: festivalButton,tag: "Festivals")


    }
    @IBAction func preferFood(_ sender: Any) {
        setInterest(button: foodButton,tag: "Food")


    }
    @IBAction func preferHistory(_ sender: Any) {
        setInterest(button: historyButton,tag: "History")


    }
    func setInterest(button : UIButton , tag : String){
        if interestDictionary[tag] != nil {
        if   self.interestDictionary[tag] as! Int == 1{
            self.interestDictionary[tag] = 0 // emin degilim
            self.interestRef.child("USERS").child(userUid).child("INTERESTS").updateChildValues([tag:0])
            button.backgroundColor = UIColor.lightGray
            button.setTitleColor(UIColor.black,for: UIControlState.normal)

        
        }else{
            print(self.interestDictionary[tag])

            self.interestDictionary[tag] = 1
            print(self.interestDictionary[tag])
            self.interestRef.child("USERS").child(self.userUid).child("INTERESTS").updateChildValues([tag:1])
            button.backgroundColor = UIColor.purple
            button.setTitleColor(UIColor.white,for: UIControlState.normal)

        }
        
        }
    }
    @IBAction func preferCulture(_ sender: Any) {
        setInterest(button: cultureButton,tag: "Culture")
            }
    @IBAction func preferSightseeing(_ sender: Any) {
        setInterest(button: sightseeingButton,tag: "Sightseeing")
    }
    @IBAction func preferArchitecture(_ sender: Any) {
        setInterest(button: architectureButton,tag: "Architecture")

    }
    
    @IBAction func preferArt(_ sender: Any) {
        setInterest(button: artButton,tag: "Art")

       
    }
    
}
