//
//  CityDetailViewController1.swift
//  travel
//
//  Created by Ata Aygen on 14.01.2018.
//  Copyright © 2018 Ata Aygen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher
import FirebaseStorage
import Alamofire



class CityDetailViewController: UIViewController ,CityDataDelegate{
    
    
    @IBOutlet weak var backButton: UIButton!
    
    var userUid : String?
    var cityNameStr : String?
    var countryNameStr : String?
    var citydata = CityDataSource()
    var savedCities: [NSDictionary] = []
    var previousView: String = ""
    
    var currency: String = ""
    
    var pop: String = ""
    @IBOutlet weak var cityInfo: UILabel!
    
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    
    @IBOutlet weak var cityName: UILabel?
    @IBOutlet weak var countryName: UILabel?
    
    
    var ref :DatabaseReference!
    
    let storage = Storage.storage()
    var selectedCity : NSDictionary = [:]
    let cityData = CityDataSource()
    var  longitude : Double = 0.0
    var latitude : Double = 0.0
    
    var attractionNames = Array<String>()
    var attractionBookingInfo =  Array<String> ()
    var attractionDescription =  Array<String> ()
    var imageUrls = Array <String> ()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var isSaved : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.cityImage.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.cityImage.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        ref = Database.database().reference()
        
        setCity()
        
        setImage()
                     let dataUrl = "https://www.triposo.com/api/v2/location.json?id=\(cityNameStr!)&fields=intro,properties&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"

        Alamofire.request(dataUrl,method:.get).responseJSON{ response in
            let jsonDictionary = response.result.value as? NSDictionary
            
            do
            {
                    let resultArray = jsonDictionary?["results"]! as! NSArray
                for result in resultArray{
                    let resultDictionary = result as! NSDictionary
                    let intro = resultDictionary["intro"]! as! String
                    DispatchQueue.main.async() {
                        self.cityInfo.text = intro
                        self.cityInfo.font = UIFont(name: "Georgia", size: 16)
                    }
                    let propertiesArray = resultDictionary["properties"] as! NSArray
                    
                    for item in propertiesArray{
                        let dict = item as! NSDictionary
                        self.pop = dict["value"]! as! String
                        DispatchQueue.main.async() {
                            self.population.text = "Population : \(self.pop)"
                            self.population.font = UIFont(name: "Georgia", size: 14)
                        }
                    }
                }
            }catch{
                print("We have a JSON exception")
            }
        }
        cityData.delegate = self
      
        
        self.cityName?.text = cityNameStr
        self.countryName?.text = "\(cityNameStr!),\(countryNameStr!)"
        self.countryName?.font = UIFont(name: "Georgia-Bold", size: 20)
        self.countryName?.textColor = UIColor.black
        
        // Do any additional setup after loading the view.
    }
    func setCity(){
        if isSaved{
            cityNameStr = (("\(selectedCity["CityName"]!)") as! String)
            countryNameStr = (("\(selectedCity["CountryName"]!)") as! String)
            
        }else{
            cityNameStr = (("\(selectedCity["DestinationCity"]!)" ) as String)
            countryNameStr = (("\(selectedCity["Country"]!) ") as String)
        }

    }
   func setImage(){
    let storageRef = storage.reference().child("\(cityNameStr!).jpg")
    storageRef.downloadURL { (url, error)-> Void in
        if (url != nil){
            let newUrl = (url?.absoluteString)
            self.cityImage.kf.setImage(with: URL(string : newUrl!))
            self.activityIndicator.stopAnimating()
        }else{
            self.cityImage.kf.setImage(with: URL (string :"http://pic.triposo.com/ios/urchin_17_1/pic/\(self.cityNameStr!).jpg") )
            self.activityIndicator.stopAnimating()


        }
    }
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(previousView == "CityView"){
            if  let nextView = segue.destination as? CityViewController{
                nextView.cityDataSource = self.citydata
                nextView.currency = self.currency
                nextView.userUid = self.userUid
                nextView.savedCitiesList = self.savedCities
            }
        }
        else if(previousView == "SavedCities"){
            if let nextView = segue.destination as? UserTabController{
                nextView.userUid = self.userUid
                let profileController = nextView.viewControllers?[0] as! UserProfileController
                profileController.userUid = self.userUid
                let savedLocationsController = nextView.viewControllers?[1] as! SavedLocationsController
                savedLocationsController.userUid = self.userUid
                savedLocationsController.cityList = self.savedCities
                let searchController = nextView.viewControllers?[2] as! HomePageViewController
                searchController.savedCities = self.savedCities
                nextView.selectedViewController = nextView.viewControllers?[1]
            }
        }
        if let nextView = segue.destination as? CityAttractionController{
            nextView.attractionNames = self.attractionNames
            nextView.attractionDescription = self.attractionDescription
            nextView.imageUrls = self.imageUrls
            nextView.cityDict = self.selectedCity
            nextView.currency = self.currency
            nextView.userUid = self.userUid!
            nextView.cityDataSource = self.citydata
            nextView.savedCities = self.savedCities
            nextView.originView = self.previousView
            nextView.isSaved = self.isSaved
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(previousView)
        var cityNameStr = ""
        if isSaved{
            cityNameStr = selectedCity["CityName"] as! String
        }else{
            cityNameStr = (selectedCity["DestinationCity"]! as! String)
        }
        ref.child("CITY").child(cityNameStr).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var cityInfo = snapshot.value as? NSDictionary
            
            if let coordinates = cityInfo?["COORDINATES"] as? NSDictionary{
                self.longitude = (coordinates["Longitude"] as? Double)!
                print((coordinates["Longitude"] as? Double)!)
                self.latitude = (coordinates["Latitude"] as? Double)!
                
            }
            
            
            self.getAttractionData(city : cityNameStr  as! String)
        })
    }
    func getAttractionData(city : String){
        
        let url = "https://www.triposo.com/api/20171027/poi.json?location_id=\(city)&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
        print(url)
        Alamofire.request(url,method:.get).responseJSON{ response in
            let jsonDictionary = response.result.value as? NSDictionary
            let resultArray = jsonDictionary?["results"]! as? NSArray
            print(resultArray?.count)
            for item in resultArray!{
                let itemDictionary = item as? NSDictionary
                let imageArray = itemDictionary!["images"] as? NSArray
                if((imageArray?.count)! > 0){
                    let imageItem = imageArray![0] as? NSDictionary
                    let imageInfoDic = imageItem!["sizes"] as? NSDictionary
                    let details = imageInfoDic!["medium"] as? NSDictionary
                    let url = details!["url"] as? String
                    self.imageUrls.append(url!)
                    
                }else{
                    self.imageUrls.append("empty")
                }
                self.attractionNames.append((itemDictionary!["name"])! as! String)
                self.attractionDescription.append((itemDictionary!["snippet"])! as! String)
                
                //   self.imageUrls.append(url)
                //   self.attractionNames.append(itemDictionary)
                
            }
        }
    }
    
    func saveImage(image: UIImage, cityname: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(cityNameStr!).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @IBAction func addCities(_ sender: Any) {
               countryNameStr?.remove(at: (countryNameStr?.index(before: (countryNameStr?.endIndex)!))!)
        ref.child("SavedCities").child("\(self.userUid!)").observeSingleEvent(
            of: DataEventType.value, with: { (snapshot) in
                
                if snapshot.hasChild("\(self.cityNameStr!)"){
                    
                    let alert = UIAlertController(title: "", message: "You already have the city in your list!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                    self.present(alert, animated:true,completion:nil)
                    
                    
                    //ALERT you already added this city
                }else{
                    
                    self.ref.child("SavedCities").child("\(self.userUid!)").updateChildValues(["\(self.cityNameStr!)" : "\(self.countryNameStr!)"])
                    
                    let alert = UIAlertController(title: "Done!", message: "The city has been added to your list!", preferredStyle: UIAlertControllerStyle.alert)
                     self.savedCities.append(["CityName":"\(self.cityNameStr!)" ,"CountryName":"\(self.countryNameStr!)"])
                      print(["\(self.cityNameStr!)" : "\(self.countryNameStr!)"])
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                    self.present(alert, animated:true,completion:nil)
                    if(self.activityIndicator.isAnimating){
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            let success = self.saveImage(image: self.cityImage.image!, cityname: self.cityNameStr!)
                            print(success)
                           
                          
                        })
                    }
                    else{
                        let success = self.saveImage(image: self.cityImage.image!, cityname: self.cityNameStr!)
                        print(success)
                    }
                    
                    
                    
                    // ALERT the city has been added to your list!
                    
                    
                }
                
        } )
    }
    @IBAction func backAction(_ sender: UIButton) {
        print(previousView)
        if(previousView == "CityView"){
            self.performSegue(withIdentifier:"DisplayCityList" , sender: Any?.self)
        }
        if(previousView == "SavedCities"){
            self.performSegue(withIdentifier: "DisplaySavedCities", sender: Any?.self)
        }
    }
    
}
