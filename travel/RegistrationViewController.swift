//
//  RegistrationViewController.swift
//  travel
//
//  Created by Duru Coskun on 10/05/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationViewController: UIViewController {

    var ref : DatabaseReference!

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func createAnAccount(_ sender: Any) {
               }
    
    @IBAction func createAccount(_ sender: UIButton) {
        createAcc: do{
        if self.email.text==""{
            let alert = UIAlertController(title: "Oops!", message: "E-mail cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated:true,completion:nil)
            break createAcc
        }
        if self.password.text==""{
            let alert = UIAlertController(title: "Oops!", message: "E-mail cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated:true,completion:nil)
            break createAcc
            }
        Auth.auth().createUser(withEmail: email.text!, password: password.text!,completion: { (user, error) in
            //check the user is not nill
            if user != nil {
                
                // SET USERNAME and Email
              
              self.ref.root.child("USERS").child((user?.uid)!).setValue(["username":self.username.text,"email":self.email.text])
                             self.ref.root.child("USERS").child((user?.uid)!).child("INTERESTS").setValue(["Festivals":0,"Sightseeing":0,"Art":0,"Culture":0,"Nightlife":0,"Shopping":0,"Food":0,"Architecture":0,"Safety":0,"History":0])
                
                //user is found
                self.performSegue(withIdentifier: "showLoginPage", sender: self)
            }
            else {
                
            }
        })
        

    }
    }


    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
self.view.backgroundColor = UIColor (patternImage:UIImage(named : "travelling-1.png")!)
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

}
