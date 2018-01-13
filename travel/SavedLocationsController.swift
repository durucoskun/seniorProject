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
    
    
    var cityList : [NSDictionary] = []
    var userUid : String!
    var infoDictionary : NSDictionary = [:]
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
            infoDictionary = cityList[indexPath.row]
            let city = infoDictionary["CityName"] as! String
            let country = infoDictionary["CountryName"] as! String
            
            let cityFont = [NSFontAttributeName: UIFont(name:"Georgia-Bold", size:15), NSForegroundColorAttributeName: UIColor.white]
            
            let countryFont = [NSFontAttributeName : UIFont(name: "Georgia", size: 15), NSForegroundColorAttributeName: UIColor.black]
        
            cityCell?.cityName.attributedText = NSMutableAttributedString(string: "\(city)", attributes: cityFont)
            //cityCell?.cityImage.kf.setImage(with: URL (string : "https://firebasestorage.googleapis.com/v0/b/travelapp-31a9e.appspot.com/o/\(city).jpg?alt=media&token=c5f0100b-4f5d-4ec6-a1b0-61a197598ecf"))
            if let image = getSavedImage(named: "\(city).png") {
                print(image.size)
                cityCell?.cityImage.image = image
            }
            
            cityCell?.countryName.attributedText = NSMutableAttributedString(string:"\(country)",attributes: countryFont)
        
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
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}

  
