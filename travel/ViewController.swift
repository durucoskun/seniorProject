//
//  ViewController.swift
//  travel
//
//  Created by Ata Aygen on 13/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController ,UITableViewDelegate {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!,completion: { (user, error) in
            //check the user is not nill
            if let u = user {
                //user is found
                self.message.text = ""
                self.performSegue(withIdentifier: "showMainPage", sender: self)
            }
            else {
                self.message.text = "Invalid email or password!"
            }
        })
        
        
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

