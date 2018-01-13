//
//  CityDetailViewController.swift
//  travel
//
//  Created by Duru Coskun on 25/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher
import FirebaseStorage
import Alamofire



class CityDetailViewController: UIViewController ,CityDataDelegate{
    
    
    
    var userUid : String?
    var cityname : String?
    var countryname : String?
    var citydata = CityDataSource()

    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference()
        
        let storageRef = storage.reference().child("\(selectedCity["DestinationCity"]!).jpg")
        storageRef.downloadURL { (url, error)-> Void in
            if (url != nil){
                let newUrl = (url?.absoluteString)
                self.cityImage.kf.setImage(with: URL(string : newUrl!))
            }else {
                self.cityImage.kf.setImage(with: URL (string : "https://firebasestorage.googleapis.com/v0/b/travelapp-31a9e.appspot.com/o/Prag.jpg?alt=media&token=c5f0100b-4f5d-4ec6-a1b0-61a197598ecf"))
            }
        }
        
        let networkSession = URLSession.shared
        let dataUrl = "https://www.triposo.com/api/v2/location.json?id=\(selectedCity["DestinationCity"]!)&fields=intro,properties&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
        /// deneme :december
     //   let coordinateURL = "https://www.triposo.com/api/20171027/poi.json?location_id=\(cityName)&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
        var req = URLRequest(url: URL(string: dataUrl)!)
        
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = networkSession.dataTask(with: req) {(data,response,error) in print("Data")
            
            let jsonReadable = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            do
            {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                
                let resultArray = jsonDictionary["results"]! as! NSArray
                for result in resultArray{
                    let resultDictionary = result as! NSDictionary
                    let intro = resultDictionary["intro"]! as! String
                    DispatchQueue.main.async() {
                        self.cityInfo.text = intro
                    }
                    let propertiesArray = resultDictionary["properties"] as! NSArray
                    
                    for item in propertiesArray{
                        let dict = item as! NSDictionary
                        self.pop = dict["value"]! as! String
                        DispatchQueue.main.async() {
                            self.population.text = "Population : \(self.pop)"
                        }
                        // self.population.text = "Population :\(self.pop)"
                    }
                    
                                }
            }
            catch
            {
                print("We have a JSON exception")
            }
            
            
            
        }
        dataTask.resume()
        self.title = "\(((selectedCity["DestinationCity"]) as AnyObject).uppercased!)"
        
        cityData.delegate = self
        // "DESTINATION : \(city["DestinationCity"]!
        
        cityname = (("\(selectedCity["DestinationCity"]!)" ) as String)
        countryname = (("\(selectedCity["Country"]!) ") as String)
        self.cityName?.text = cityname
        self.countryName?.text = countryname
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let nextView = segue.destination as? CityViewController{
            nextView.cityDataSource = self.citydata
            nextView.currency = self.currency
            nextView.userUid = self.userUid
        }
        else if let nextView = segue.destination as? CityAttractionController{
            nextView.attractionNames = self.attractionNames
            nextView.attractionDescription = self.attractionDescription
            nextView.imageUrls = self.imageUrls
            nextView.cityDict = self.selectedCity
            nextView.currency = self.currency
            nextView.userUid = self.userUid!
            nextView.cityDataSource = self.citydata
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //   cityData.loadCityDetail(cityId: selectedCity!.cityId)
        ref.child("CITY").child("\(selectedCity["DestinationCity"]!)").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var cityInfo = snapshot.value as? NSDictionary
            
                if let coordinates = cityInfo?["COORDINATES"] as? NSDictionary{
                    self.longitude = (coordinates["Longitude"] as? Double)!
                    print((coordinates["Longitude"] as? Double)!)
                    self.latitude = (coordinates["Latitude"] as? Double)!
            
            }
            
            
            self.getAttractionData(city : self.selectedCity["DestinationCity"]!  as! String)

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
            try data.write(to: directory.appendingPathComponent("\(cityname).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
   
    @IBAction func addCities(_ sender: Any) {
        var name = cityname as String!
        var country = countryname as String!
        
        ref.child("SavedCities").child("\(self.userUid!)").observeSingleEvent(
            of: DataEventType.value, with: { (snapshot) in
                
                if snapshot.hasChild("\(name!)"){
                    
                    let alert = UIAlertController(title: "", message: "You already have the city in your list!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                    self.present(alert, animated:true,completion:nil)
                    
                    
                    //ALERT you already added this city
                }else{
                    
                    self.ref.child("SavedCities").child("\(self.userUid!)").child("\(name!)").setValue(["City Name":"\(name!)","Country":"\(country!)"])
                    
                    let alert = UIAlertController(title: "Oops!", message: "The city has been added to your list!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                    self.present(alert, animated:true,completion:nil)
                    let success = self.saveImage(image: self.cityImage.image!, cityname: name!)
                    print(success)
                    
                    // ALERT the city has been added to your list!
                    
                    
                }
                
        } )
    }
    
                             }
