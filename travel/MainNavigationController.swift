//
//  MainNavigationController.swift
//  travel
//
//  Created by Duru Coskun on 20/05/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        if isLoggedIn(){
            let homePage = HomePageViewController()
            viewControllers = [homePage]
        }else {
            perform(#selector(showLoginPage),with : nil,afterDelay: 0.01)
        }
        
    }

    fileprivate func isLoggedIn()-> Bool{
       // return UserDefaults.standard.isLoggedIn()
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func showLoginPage(){
        let loginController = ViewController()
        present(loginController,animated: true,completion: {
            
        })
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
