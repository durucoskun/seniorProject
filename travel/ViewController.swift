//
//  ViewController.swift
//  travel
//
//  Created by Ata Aygen on 13/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController ,UITableViewDelegate{

    @IBOutlet weak var message: UILabel!
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
        FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!,completion: { (user, error) in
            //check the user is not nill
            if user != nil {
                //user is found
                self.message.text = ""
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "showMainPage", sender: self)
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

