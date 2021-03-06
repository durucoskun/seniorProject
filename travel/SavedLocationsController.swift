//
//  SavedLocationsController.swift
//  travel
//
//  Created by Duru Coskun on 02/12/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//


import UIKit
import  Kingfisher
import FirebaseDatabase

class SavedLocationsController : UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var ref : DatabaseReference!
    var cityList : [NSDictionary] = []
    var userUid : String!
    var infoDictionary : NSDictionary = [:]
    var cityCell : CityCell? = nil
    var interestDictionary : [String : Int] = [:]


    @IBAction func removeCity(_ sender: Any) {
        ref =  Database.database().reference()
        let buttonPosition = (sender as AnyObject).convert!(CGPoint.zero, to: self.cityTableView)
       let indexPath = self.cityTableView.indexPathForRow(at: buttonPosition)
//databaseden sil
        let dict = cityList[(indexPath?.row)!]
        ref.child("SavedCities").child(userUid!).child(dict["CityName"] as! String).removeValue()
        cityList.remove(at: (indexPath?.row)!)
        self.cityTableView.reloadData()
    }
   
   
  
    
    @IBOutlet var cityTableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved Locations"
        cityTableView.dataSource = self
        ref = Database.database().reference()
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
            }else if cityCell?.cityImage.image == nil{
                  cityCell?.cityImage.kf.setImage(with: URL (string :"http://pic.triposo.com/ios/urchin_17_1/pic/\(city).jpg") )
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
        if let nextView = segue.destination as? CityDetailViewController{
            let selectedCell = sender as! CityCell
            let indexPath = self.cityTableView.indexPath(for : selectedCell)
nextView.isSaved = true
            nextView.selectedCity = self.cityList[(indexPath?.row)!]
            nextView.savedCities = self.cityList
            nextView.userUid = self.userUid
            nextView.previousView = "SavedCities"
            nextView.isSaved = true
            nextView.interestDictionary = self.interestDictionary
        }
        
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}

  
