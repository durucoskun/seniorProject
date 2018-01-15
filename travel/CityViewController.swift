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
    var savedCitiesList: [NSDictionary] = []
    var interestDictionary : [String : Int] = [:]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DESTINATIONS"
        cityTableView.dataSource = self
        print(userUid)
        print(self.savedCitiesList)
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
        
        let priceFont = [NSFontAttributeName : UIFont(name: "Georgia", size: 15), NSForegroundColorAttributeName: UIColor.black]
        let cityFont = [NSFontAttributeName: UIFont(name:"Georgia-Bold", size:15), NSForegroundColorAttributeName: UIColor.white]
        let scoreFont = [NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 17), NSForegroundColorAttributeName: UIColor.black]
        
        cell = cityTableView.dequeueReusableCell(withIdentifier: "Identifier",for: indexPath as IndexPath) as! CityTableViewCell
        
        let city = (cityDataSource.sortedArray?[indexPath.row])!
        
        cell?.score.attributedText = NSMutableAttributedString(string: String(format: "%.2f", ((city["Average"]! as! Float)*100/100)), attributes: scoreFont)
        cell?.score.layer.cornerRadius = (cell?.score.frame.width)!/2
        cell?.score.layer.masksToBounds = true
        
        cell?.destination.setAttributedTitle(NSMutableAttributedString(string:"\(city["DestinationCity"]!), \(city["Country"]!)", attributes: cityFont),for: UIControlState.normal)
        cell?.destination.contentHorizontalAlignment = .left
        
        cell?.price.setAttributedTitle(NSMutableAttributedString(string:"Lowest Price: \(city["MinPrice"]!) \(currency)", attributes:priceFont),for: UIControlState.normal)
        cell?.price.contentHorizontalAlignment = .left
        
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
            cityDetailController.interestDictionary = self.interestDictionary

        cityDetailController.userUid = self.userUid
        cityDetailController.citydata = self.cityDataSource
        cityDetailController.currency = self.currency
        cityDetailController.selectedCity = (cityDataSource.sortedArray?[(selectedIndexPath?.row)!])!
        cityDetailController.savedCities = self.savedCitiesList
        cityDetailController.previousView = "CityView"
    
        }
        else if let nextView = segue.destination as? UserTabController{
            nextView.userUid = self.userUid
            nextView.interestDictionary = self.interestDictionary
            let profileController = nextView.viewControllers?[0] as! UserProfileController
            profileController.userUid = self.userUid
            profileController.interestDictionary = self.interestDictionary
            let savedLocationsController = nextView.viewControllers?[1] as! SavedLocationsController
            savedLocationsController.userUid = self.userUid
            savedLocationsController.cityList = self.savedCitiesList
            let searchController = nextView.viewControllers?[2] as! HomePageViewController
            searchController.savedCities = self.savedCitiesList
            searchController.interestDictionary = self.interestDictionary
        }
    }
}
