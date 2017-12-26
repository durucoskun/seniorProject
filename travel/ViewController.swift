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
    var savedCities : [String] = []
    var images : [UIImageView?] = []
    var storageRef : StorageReference!

  
    
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
                    self.userUid = user?.uid
                    self.email = user?.email
                    
                    let userTabController = self.storyboard?.instantiateViewController(withIdentifier: "UserTabController")as! UserTabController
                    
                    
                    userTabController.email = self.email
                    
                    userTabController.username = user?.displayName //// degistir
                    userTabController.selectedViewController = userTabController.viewControllers?[2]
                    let profileContoller  = userTabController.viewControllers?[0] as! UserProfileController
                    profileContoller.mail = self.email
                    profileContoller.userUid = self.userUid
                    
                    let savedLocationsController = userTabController.viewControllers?[1] as! SavedLocationsController
                    savedLocationsController.userUid = self.userUid
                    
                    let searchController = userTabController.viewControllers?[2] as! HomePageViewController
                    searchController.userUid = self.userUid

                    let semaphore = DispatchSemaphore(value: 0);
                   
              
                    self.ref.child("SavedCities").child(self.userUid!).observeSingleEvent(
                        of: DataEventType.value, with: { (snapshot) in
                            print("COK UZULUYOM")
                            if let data = snapshot.value as? [String: Any] {
                                let dataArray = Array(data)
                                let keys = dataArray.map { $0.0 }
                                self.savedCities = keys
                               print(self.savedCities.count)
                            }
                             print(self.savedCities.count)
                    }
                        
                     
                    )
                 //    semaphore.wait(timeout: DispatchTime.distantFuture);
                     semaphore.wait(timeout: DispatchTime.now());
                    
                    
                 DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    
                    print("\(self.savedCities.count) forrrr")
                    for city in self.savedCities{
                        
                        print(city)
                        let storageReference = self.storageRef.child("\(city).jpg")
                        storageReference.downloadURL { (url, error)-> Void in
                            if (url != nil){
                                let newUrl = (url?.absoluteString)
                                (self.cityImage?.kf.setImage(with: URL(string : newUrl!)))
                                self.images.append(self.cityImage)
                                print(":(((")
                            }else {
                                self.cityImage?.kf.setImage(with: URL (string : "https://firebasestorage.googleapis.com/v0/b/travelapp-31a9e.appspot.com/o/Prag.jpg?alt=media&token=c5f0100b-4f5d-4ec6-a1b0-61a197598ecf"))
                                
                                 DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                self.images.append(self.cityImage)
                                print("appended!!!")
                                })
                            }
                        }
                    }
                     DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
                    print(self.images.count)
                    savedLocationsController.images = self.images as! [UIImageView?]
                    })
                 })
                   
                   
 
                    
                    self.present(userTabController,animated: true,completion : nil)
                    
                    // maybe???   self.performSegue(withIdentifier: "UserTabController", sender: self)
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn") //
                    UserDefaults.standard.synchronize()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storageRef  = Storage.storage().reference()
        self.view.backgroundColor = UIColor (patternImage:UIImage(named : "travelling-1.png")!)
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
        }
    }
}

