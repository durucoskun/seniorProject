//
//  RegistrationViewController.swift
//  travel
//
//  Created by Duru Coskun on 10/05/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func createAnAccount(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!,completion: { (user, error) in
            //check the user is not nill
            if let u = user {
                //user is found
               /* self.performSegue(withIdentifier: "showMainPage", sender: self)
            */
            }
            else {
            }
        })
        
        }
    


    override func viewDidLoad() {
        super.viewDidLoad()

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

}
