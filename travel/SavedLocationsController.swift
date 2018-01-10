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
    
    var cityCell : CityCell? = nil

   
   
  
    
    @IBOutlet var cityTableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "DESTINATIONS"
        cityTableView.dataSource = self
        print(userUid)
       // self.view.backgroundColor = UIColor (patternImage:UIImage(named : "city.png")!)
        
        //cityDataSource.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
      // cityCell = cityTableView.dequeueReusablecityCell(withReuseIdentifier: "cityCell",for: indexPath as IndexPath) as! CityTableViewCell
        
        cityCell = cityTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
    let city = (cityList[indexPath.row])!
        
        
      cityCell?.cityName.text = "City : \(city)"
        cityCell?.cityImage.kf.setImage(with: URL (string : "https://firebasestorage.googleapis.com/v0/b/travelapp-31a9e.appspot.com/o/\(city).jpg?alt=media&token=c5f0100b-4f5d-4ec6-a1b0-61a197598ecf"))
        
        return cityCell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cityTableView.delegate = self
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int)-> Int {
        
        return (cityList.count)
        
    }
    
    
    
   
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /*
         
         if (cityCell?.destination.isSelected)!{
         }else{
         
         let selectedcityCell = sender as! CityTableViewcityCell
         
         let indexPath = self.cityTableView.indexPath(for : selectedcityCell)
         
         let controller = segue.destination as! CityDetailViewController
         
         controller.selectedCity = (cityDataSource.destinations?[indexPath!.row])!
         }
         
         
 
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cityCell = superview.superview as? CityTableViewcityCell{
                    indexPath = self.cityTableView.indexPath(for: cityCell) as NSIndexPath!
                }
            }
        }
        
        
        if  let nextView = segue.destination as? CityDetailViewController{
            nextView.selectedCity = (cityDataSource.sortedArray?[indexPath.row])!
            nextView.cityImage?.kf.setImage(with:URL(string:"gs://travelapp-31a9e.appspot.com/New York.jpg"))
            nextView.userUid = self.userUid
            nextView.citydata = self.cityDataSource
            nextView.currency = self.currency
            
        }
        
        if let nextView = segue.destination as? UserTabController{
            nextView.userUid = self.userUid
        }
        
        
       */
        
        
    }
    
    
}

  
