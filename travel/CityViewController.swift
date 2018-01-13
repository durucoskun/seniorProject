//
//  CityViewController.swift
//  travel
//
//  Created by Duru Coskun on 23/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit


class CityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, CityDataDelegate{

    
    
    
    @IBOutlet weak var score: UILabel!
    var userUid : String!
    @IBOutlet weak var cityTableView: UITableView!
    var url:String!
    var city :String!
    var cell : CityTableViewCell? = nil
    var cityDataSource = CityDataSource()
    var currency : String = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DESTINATIONS"
        cityTableView.dataSource = self
        print(userUid)
        self.view.backgroundColor = UIColor (patternImage:UIImage(named : "city.png")!)
        
        //cityDataSource.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        cell = cityTableView.dequeueReusableCell(withIdentifier: "Identifier",for: indexPath as IndexPath) as! CityTableViewCell
        let city = (cityDataSource.sortedArray?[indexPath.row])!
        cell?.score.text = String((round(city["Average"]! as! Float)*100)/100)
      cell?.destination.setTitle("DESTINATION : \(city["DestinationCity"]!)",for: UIControlState.normal)
      cell?.price.setTitle("MIN PRICE: \(city["MinPrice"]!) \(currency)",for: UIControlState.normal)
       return cell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cityTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int)-> Int {
        return (cityDataSource.sortedArray?.count)!
    }
    
    func cityListLoaded() {
        DispatchQueue.main.async {
            self.cityTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cityDetailController = segue.destination as? CityDetailViewController{
            let selectedCell = sender as! CityTableViewCell
            let selectedIndexPath = self.cityTableView.indexPath(for : selectedCell)
        
        cityDetailController.userUid = self.userUid
        cityDetailController.citydata = self.cityDataSource
        cityDetailController.currency = self.currency
        cityDetailController.selectedCity = (cityDataSource.sortedArray?[(selectedIndexPath?.row)!])!
        
    
        }else if let nextView = segue.destination as? UserTabController{
            nextView.userUid = self.userUid
            let profileController = nextView.viewControllers?[0] as! UserProfileController
            profileController.userUid = self.userUid
            let savedLocationsController = nextView.viewControllers?[1] as! SavedLocationsController
            savedLocationsController.userUid = self.userUid
        }
    }
}
