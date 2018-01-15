//
//  ViewController.swift
//  travel
//
//  Created by Ata Aygen on 13/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class ViewController: UIViewController ,UITableViewDelegate{
    
    var userUid : String!
    var email : String!
    var cityImage : UIImageView!
    var ref : DatabaseReference!
    var savedCities : [NSDictionary] = []
    var images : [UIImageView?] = []
    var storageRef : StorageReference!
    var interestRef : DatabaseReference!
    var interestDictionary : [String : Int] = [:]

  
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBAction func log_in(_ sender: UIButton) {
        login: do{
            if self.username.text==""{
                let alert = UIAlertController(title: "Oops!", message: "Username cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated:true,completion:nil)
                break login
            }
            if self.password.text == ""{
                let alert = UIAlertController(title: "Oops!", message: "Password cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated:true,completion:nil)
                break login
            }
            Auth.auth().signIn(withEmail: username.text!, password: password.text!,completion: { (user, error) in
                //check the user is not nill
                if user != nil {
                    //user is found
                    self.loginOperations(user: user)
                }
                else {
                    let alert = UIAlertController(title: "Oops!", message: "Wrong username and/or password!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: { action in
                        
                        self.password.text = ""
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    //                self.message.text = "Invalid email or password!"
                }
            })
        }
    }
    
    func loginOperations(user: User?){
        
        let userTabController = self.storyboard?.instantiateViewController(withIdentifier: "UserTabController")as! UserTabController
        let savedLocationsController = userTabController.viewControllers?[1] as! SavedLocationsController
        let profileContoller  = userTabController.viewControllers?[0] as! UserProfileController
        
        let searchController = userTabController.viewControllers?[2] as! HomePageViewController
        userTabController.email = self.email
        
        
        let semaphore = DispatchSemaphore(value: 0);
        
        DispatchQueue.main.async{
        self.ref.child("SavedCities").child(self.userUid!).observeSingleEvent(
            of: DataEventType.value, with: { (snapshot) in
                if let data = snapshot.value as? [String: String] {
                    let dataArray = Array(data)
                    let cityNames = dataArray.map { $0.0 }
                    let countries = dataArray.map{ $0.1 }
                    for i in 0..<cityNames.count{
                        self.savedCities.append(["CityName":cityNames[i],"CountryName":countries[i]])
                    }
                    print(self.savedCities)
                    //self.cityCountries = countries
                    print(self.savedCities.count)
                    savedLocationsController.cityList = self.savedCities
                    searchController.savedCities = self.savedCities
                }
                print(self.savedCities.count)
        }
            
        )
            self.interestRef = Database.database().reference().child("USERS").child(self.userUid!).child("INTERESTS")
            self.interestRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                self.interestDictionary = (snapshot.value)! as! [String : Int]
            })
        }
        //    semaphore.wait(timeout: DispatchTime.distantFuture);
//        semaphore.wait(timeout: DispatchTime.now());
//
//
//    DispatchQueue.main.async{
        
//            print("\(self.savedCities.count) forrrr")
//            for city in self.savedCities{
//
//                print(city)
//                let storageReference = self.storageRef.child("\(city).jpg")
//                storageReference.downloadURL { (url, error)-> Void in
//                    if (url != nil){
//                        let newUrl = (url?.absoluteString)
//                        (self.cityImage?.kf.setImage(with: URL(string : newUrl!)))
//                        self.images.append(self.cityImage)
//                        print(":(((")
//                    }else {
//                        self.cityImage?.kf.setImage(with: URL (string : "https://firebasestorage.googleapis.com/v0/b/travelapp-31a9e.appspot.com/o/Prag.jpg?alt=media&token=c5f0100b-4f5d-4ec6-a1b0-61a197598ecf"))
//
//
//                    }
//                }
//            }
//
//                print(self.savedCities.count)
//                 //as [String?]
//
//      }
        self.userUid = user?.uid
        self.email = user?.email
        
        userTabController.username = user?.displayName //// degistir
        userTabController.selectedViewController = userTabController.viewControllers?[2]
        profileContoller.mail = self.email
        profileContoller.userUid = self.userUid
        profileContoller.interestDictionary = self.interestDictionary
        
        
        savedLocationsController.userUid = self.userUid
        
        
        searchController.userUid = self.userUid
        savedLocationsController.cityList = self.savedCities
        self.present(userTabController,animated: true,completion : nil)
        
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn") //
        UserDefaults.standard.synchronize()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                // user is already logged in
                print("logged in")
                self?.loginOperations(user: user)
            }
            else{
                self?.view.isHidden = false
            }
        }
        ref = Database.database().reference()
        storageRef  = Storage.storage().reference()
        self.view.backgroundColor = UIColor (patternImage:UIImage(named : "travelling-1.png")!)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextView = segue.destination as? UserTabController{
            nextView.userUid = self.userUid
            nextView.username = self.username.text
            nextView.email = self.email
            nextView.interestDictionary = self.interestDictionary
        }
    }
}

