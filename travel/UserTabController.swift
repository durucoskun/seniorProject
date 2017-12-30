//
//  UserController.swift
//  travel
//
//  Created by Duru Coskun on 26/11/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import Foundation
import UIKit

class UserTabController : UITabBarController{
    
    var userUid : String!
    var username : String!
    var email : String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
             
      
       // let viewControllers = self.tabBarController?.viewControllers as! UserTabController
        
        // Profile Tab
        /*let profileController = self.tabBarController?.viewControllers? [0] as! UserProfileController
        profileController.email.text = emailxs
        profileController.username.text = username
        
        // Flight seacrh Tab
        //let flightSearchController = viewControllers?[1]
        
        // saved Places Tab
   //     let savedPlacesContoller = viewControllers?[2]
 */
        let flightSearchController = viewControllers?[2] as! HomePageViewController
        flightSearchController.userUid = self.userUid
        self.selectedIndex = 2
    }
    
}
