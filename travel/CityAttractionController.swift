//
//  CityAttractionController.swift
//  travel
//
//  Created by Duru Coskun on 03/01/2018.
//  Copyright © 2018 Ata Aygen. All rights reserved.
//

import UIKit
import Kingfisher

class CityAttractionController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var attractionTableView: UITableView!
    var cityDict: NSDictionary = [:]
    var cityAttractionCell : CityAttractionCell? = nil
    var cityName :String?
    var attractionNames = Array<String>()
    var attractionBookingInfo =  Array<String> ()
    var attractionDescription =  Array<String> ()
    var imageUrls = Array <String> ()
    var currency: String = ""
    var userUid: String = ""
    var savedCities:[NSDictionary] = []
    var cityDataSource = CityDataSource()
    var isSaved : Bool = false
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attractionTableView.dataSource = self
        attractionTableView.delegate = self
        // self.title = "DESTINATIONS"

        // self.view.backgroundColor = UIColor (patternImage:UIImage(named : "city.png")!)
        
        //cityDataSource.delegate = self
        
        // Do any additional setup after loading the view.
        
print(imageUrls.count)
    }
    
    
     func numberOfSectionsInTableView(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        cityAttractionCell = attractionTableView.dequeueReusableCell(withIdentifier: "cityAttraction", for: indexPath) as! CityAttractionCell
        
        //cityAttractionCell?.attractionInfo.text = attractionDescription[indexPath.row]
        //print(cityAttractionCell?.attractionInfo.text)
        
        
cityAttractionCell?.descriptionText.text = ("\(attractionNames[indexPath.row]) : \(attractionDescription[indexPath.row]) ")
        if (imageUrls[indexPath.row] != "empty"){
        cityAttractionCell?.attractionImageView.kf.setImage(with: URL(string : imageUrls[indexPath.row]))
        } else{
            cityAttractionCell?.attractionImageView.image = #imageLiteral(resourceName: "profileIcon")
        }
               return cityAttractionCell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int)-> Int {
       
        return attractionNames.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isSaved{
            if  let nextView = segue.destination as? CityDetailViewController{
                nextView.selectedCity = self.cityDict
                nextView.citydata = self.cityDataSource
                nextView.currency = self.currency
                nextView.userUid = self.userUid
                nextView.savedCities = self.savedCities
                nextView.isSaved = true
            }

        }else{
        if  let nextView = segue.destination as? CityDetailViewController{
            nextView.selectedCity = self.cityDict
            nextView.citydata = self.cityDataSource
            nextView.currency = self.currency
            nextView.userUid = self.userUid
            nextView.savedCities = self.savedCities
            }
            
    }
    }
    
    
    
    
    
   
        
  
    


}
