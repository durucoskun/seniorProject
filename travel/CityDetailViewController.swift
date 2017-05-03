//
//  CityDetailViewController.swift
//  travel
//
//  Created by Duru Coskun on 25/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController ,CityDataDelegate{
    @IBOutlet weak var cityName: UILabel!
    
    var selectedCity : NSDictionary = [:]
    let cityData = CityDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "\(selectedCity["DestinationCity"]!)"
        
      cityData.delegate = self
        
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
