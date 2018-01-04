//
//  CityAttractionController.swift
//  travel
//
//  Created by Duru Coskun on 03/01/2018.
//  Copyright © 2018 Ata Aygen. All rights reserved.
//

import UIKit

class CityAttractionController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var attractionTableView: UITableView!
    var cityAttractionCell : CityAttractionCell? = nil
    var cityName :String?
    var attractionNames = Array<String>()
    var attractionBookingInfo =  Array<String> ()
    var attractionDescription =  Array<String> ()
    var imageUrls = Array <String> ()
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
        
        
        print("merhaba \(indexPath.row)")
        
               return cityAttractionCell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int)-> Int {
        
        return attractionNames.count
        
    }
    
    
    
    
    
    
   
        
  
    


}
