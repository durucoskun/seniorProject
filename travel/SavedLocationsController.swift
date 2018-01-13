//
//  SavedLocationsController.swift
//  travel
//
//  Created by Duru Coskun on 02/12/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//


import UIKit
import  Kingfisher

class SavedLocationsController : UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    var cityList : [String?] = []
    var userUid : String!
    var cityDictionary : NSDictionary = [:]
    var cityCell : CityCell? = nil

   
   
  
    
    @IBOutlet var cityTableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DESTINATIONS"
        cityTableView.dataSource = self
        //cityDataSource.delegate = self
        }
    
    
    func numberOfSectionsInTableView(in tableView: UITableView) -> Int {
        return 1
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
     
        
        cityCell = cityTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
    let city = (cityList[indexPath.row])!
            cityDictionary = ["City" : city]
        
      cityCell?.cityName.text = "City : \(city) "
        cityCell?.cityImage.kf.setImage(with: URL (string : "https://firebasestorage.googleapis.com/v0/b/travelapp-31a9e.appspot.com/o/\(city).jpg?alt=media&token=c5f0100b-4f5d-4ec6-a1b0-61a197598ecf"))
        
        return cityCell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cityTableView.delegate = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int)-> Int {
        
        return (cityList.count)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /*
        
        if let nextView = segue.destination as? CityDetailViewController{
            let selectedCell = sender as! CityCell
            let indexPath = self.cityTableView.indexPath(for : selectedCell)
            nextView.cityname = cityList[(indexPath?.row)!]
        }
 */
        
        
    }
    
    
}

  
