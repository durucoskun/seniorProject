//
//  CityDataSource.swift
//  travel
//
//  Created by Ata Aygen on 13/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit
import Alamofire


@objc protocol CityDataDelegate{
    
    @objc optional func cityListLoaded()
    @objc optional func cityDetailsLoaded (place : Place)
    
}

extension String {
    
    func firstCharacterUpperCase() -> String {
        if let firstCharacter = characters.first, characters.count > 0 {
            return replacingCharacters(in: startIndex ..< index(after: startIndex), with: String(firstCharacter).uppercased())
        }
        return self
    }
}

class CityDataSource: NSObject {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var ref :DatabaseReference!
    
    public var quotes : Array<Quote>?
    public var places : Array<Place>?
    public var carriers : Array<Carrier>?
    public var currencies : Array<Currency>?
    public var destinations : Array <NSDictionary>? = Array()
    public var sortedArray : Array <NSDictionary>? = Array()
    var userUid: String = ""
    var delegate : CityDataDelegate?
    var userPrice : Double = 0.0
    
    func loadCities(url: String,code : String, vc: HomePageViewController, uid: String, price: Int){
        self.userUid=uid
        self.userPrice = Double(price)
        ref = Database.database().reference()
        destinations?.removeAll()
        let semaphore = DispatchSemaphore(value: 0);
        let networkSession = URLSession.shared
        
        var req = URLRequest(url: URL(string: url)!)
        
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = networkSession.dataTask(with: req) {(data,response,error) in print("Data")
            
            let jsonReadable = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                       do{
                
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                
                let quoteArray = jsonDictionary["Quotes"]! as! NSArray
                self.getQuotes(quoteArray: quoteArray)
                
                let placeArray = jsonDictionary["Places"]! as! NSArray
                self.getPlaces(placeArray : placeArray)
                
                let carrierArray = jsonDictionary["Carriers"]! as! NSArray
                self.getCarriers (carrierArray : carrierArray)
                
                let currencyArray = jsonDictionary["Currencies"]! as! NSArray
                //    self.currencies (currencyArray : currencyArray)
                
                self.checkDestinations(code: code)
                semaphore.signal();
            }
            catch{
                print("We have a JSON exception")
            }
        }
        dataTask.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture);
        print("waited")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            if(self.sortedArray?.count as! Int == 0){
                print("array empty")
                self.showNoDestError(fromViewController: vc)
                return
            }
        self.showNextView(fromViewController: vc)
        
        })
    }
    
    func showNextView(fromViewController: HomePageViewController) {
        fromViewController.goToNextView()
    }
    
    func showNoDestError(fromViewController: HomePageViewController){
        fromViewController.showNoDestAlert()
    }
    
    func checkDestinations (code : String){
        
        var interest: Array<String> = []
        let intRef = ref.child("USERS").child(self.userUid).child("INTERESTS")
        var averages: [String: Float] = [:]
        intRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                
                let dataArray = Array(data)
                let keys = dataArray.map { $0.0 }
                for i in 0..<dataArray.count{
                    if((dataArray[i].value as! Int) == 1){
                        interest.append(keys[i])
                    }
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            let avgRef = self.ref.child("CITY")
            avgRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let cityName = snap.key
                    var average:Float = 0;
                    if((snap.childSnapshot(forPath: "INTERESTS").value as? [String:Any]) == nil){}
                    else{
                        var interests = snap.childSnapshot(forPath: "INTERESTS").value as! [String:Any]

                        for i in 0..<interest.count{
                            if(interests[interest[i]] as? Float != nil){
                            average += interests[interest[i]] as! Float

                            }
                        }
                        averages[cityName] = 0.0
                        average = average/Float(interest.count)
                        averages[cityName] = average
                        
                    }
                   /* for i in 0..<interest.count{
                        average += interests[interest[i]] as! Float
                    }*/
                    
                }
                
            })
        } )
        
        
        
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {

    var destination : Int
        for city in self.places!{
            let newCity = city as! Place
            
            if (newCity.code == code){
                
                let id = newCity.placeId
                
                for quote in self.quotes!{
                    let newQuote = quote as! Quote
                    if (quote.outbound.originId == id){
                        destination =  quote.outbound.destinationId
                        for place in self.places!{
                            let nextCity = place as! Place
                            var cityScore: Float = 0.0
                            if (destination == nextCity.placeId){
                                if(averages[nextCity.cityName!] != nil) {
                                    cityScore = averages[nextCity.cityName!]!
                                }
                                let destinationDictionary: [String:Any] = ["DestinationCity":nextCity.cityName!,"MinPrice" :quote.minPrice,"Country":nextCity.countryName, "Average": cityScore ]
                                
                                if (destinationDictionary["MinPrice"] as! Double ) < self.userPrice {
                                (self.destinations?.append(destinationDictionary as NSDictionary))!
                                }
                            }
                        }
                    }
                }
            }
        }
    self.sortedArray = (self.destinations as! NSArray).sortedArray(using: [NSSortDescriptor(key: "Average", ascending: false)]) as! [[String:AnyObject]] as Array<NSDictionary>
    var noDuplicates = [[String: AnyObject]]() as Array<NSDictionary>
    var usedNames = [String]()
    /*
    for dict in self.sortedArray! {
        if let name = dict["DestinationCity"], !usedNames.contains(name as! String) {
            noDuplicates.append(dict)
            usedNames.append(name as! String)
        }
    }
     */
    check: do{
    let count = self.sortedArray?.count as! Int
    if(count==0){
        break check
    }
    for i in 1 ..< count{
        if i >= (self.sortedArray?.count)!{
            break
        }
        print(self.sortedArray?[i-1])
        print()
        let dictFirst = (self.sortedArray?[i])!
        let dictSecond = (self.sortedArray?[i-1])!
        if (dictFirst["DestinationCity"] as! String == dictSecond["DestinationCity"] as! String){
            if (dictFirst["MinPrice"] as! Double ) < (dictSecond["MinPrice"] as! Double ){
                self.sortedArray?.remove(at: i-1)
            }else{
                self.sortedArray?.remove(at: i)

            }
        }
        }
    }
   // self.sortedArray = noDuplicates
})
        if(self.sortedArray?.count as! Int == 0){
            return
        }
        loadCityList()
        
    }
    
    func getQuotes(quoteArray : NSArray){
        
        quotes = Array()
        for quote in quoteArray{
            let quoteDictionary = quote as! NSDictionary
            
            let newQuote = Quote(quoteId :quoteDictionary["QuoteId"]! as! Int ,
                                 minPrice : quoteDictionary ["MinPrice"]! as! Double,
                                 direct : quoteDictionary["Direct"]! as! Bool,
                                 outbound :OutboundLeg(dictionary :(quoteDictionary["OutboundLeg"]! as! NSDictionary) as! [String : Any] as NSDictionary),
                                 inbound:InboundLeg(dictionary: (quoteDictionary["InboundLeg"]! as! NSDictionary) as! [String : Any]),
                                 date : quoteDictionary["QuoteDateTime"]! as! String)
            
            (quotes?.append(newQuote))!
        }
    }
    func getInterestScoreByName(){
        
        
        do{
            self.ref.child("CITY").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let cityName = snap.key
                    
                    // account id token degisebilir.
                    let scoreUrl = "https://www.triposo.com//api/20171027/tag.json?location_id=\(cityName)&type=background&fields=name,score&account=RNTTF1VB&token=49onrrp87tqkx4pa3zr2nub0fi2m9equ"
                    Alamofire.request(scoreUrl,method: .get).responseJSON{ response in
                        let infoDictionary = (response.result.value) as? NSDictionary
                        if (infoDictionary?["results"] != nil){
                            
                            let info = infoDictionary?["results"] as? NSArray
                            
                            for scoreItem in info!{
                                let scoreDictionary = scoreItem as! NSDictionary
                                let score = scoreDictionary["score"] as! Double
                                let tag = scoreDictionary["name"] as! String
                                
                                if (tag == "Art" || tag == "Culture" || tag == "History" || tag == "Architecture" || tag == "Festivals" || tag == "Food" ){
                                    self.ref.child("CITY").child("\(cityName)").child("INTERESTS").updateChildValues(["\(tag)" : (score*2)])
                                }
                            }
                        }
                    }
                }
                
            })}catch{
                
        }


    }
    
    func getInterestScoreByCoordinate(city : String ){
        var latitude = 0.0
        var longitude = 0.0
        getCityCoordinates(latitude: latitude,longitude: longitude)
        
        do{
            self.ref.child("CITY").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                var childSnaphot = snapshot.childSnapshot(forPath: "\(city)") as? DataSnapshot
                
                var cityInfo = snapshot.value as? NSDictionary
                
                 if let value = cityInfo?["\(city)"] as? NSDictionary{
                 if let coordinates = value["COORDINATES"] as? NSDictionary{
                 longitude = (coordinates["Longitude"] as? Double)!
                 latitude = (coordinates["Latitude"] as? Double)!
                 }
                 }
                
                 let scoreURL = "http://www.triposo.com//api/20171027/local_score.json?coordinates=\(latitude),\(longitude)&account=RNTTF1VB&token=49onrrp87tqkx4pa3zr2nub0fi2m9equ"
                 
                 // let scoreUrl = "https://www.triposo.com/api/v2/location.json?id=\(city)&fields=intro,properties&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
                 Alamofire.request(scoreURL,method:.get).responseJSON{ response in
                 
                 
                 let info = (response.result.value)  as? NSDictionary
                 if (info?["results"] != nil){
                 print("hello")
                 let intro = info?["results"] as? NSArray
                 for item in intro!{
                 let itemDictionary = item as! NSDictionary
                 let scores = itemDictionary["scores"] as! NSArray
                 //print(itemDictionary)
                 
                 for scoreInfo in scores{
                 let dictionary = scoreInfo as! NSDictionary
                 let score = dictionary["score"] as! Double
                 let label = dictionary["tag_label"] as! String
                 self.ref.child("CITY").child(city).child("INTERESTS").updateChildValues(["\(label.firstCharacterUpperCase())":score])
                 }
                 }
                 
                                     }                             }
            })
        }catch{
            
        }
        

        
    }
    
    
                func getCityCoordinates(latitude : Double,longitude : Double){
                /*
                    let networkSession = URLSession.shared
                  //  var city = "\(newPlace.cityName!)"
                    
                    let whitespace = NSCharacterSet.whitespaces
                    
                    let phrase = city
                    let range = phrase.rangeOfCharacter(from: whitespace)
                    
                    if let test = range {
                        //// bosluklu cityler icin check edilmeli
                        */
                  //  }else{
                        
                      /*
                        do{
                            
                            // let coordinateURL = "https://www.triposo.com/api/20171027/location.json?id=\(city)&type=city&fields=coordinates&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
                     
                            // COORDINATE PART
                            
                            var req = URLRequest(url: URL(string: coordinateURL)!)
                            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            let dataTask = networkSession.dataTask(with: req) {(data,response,error) in
                                
                                let jsonReadable = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                
                                do{
                                    
                                    
                                    let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                                    
                                    let coordinates = jsonDictionary["results"] as! NSArray
                                    var latitude = 0.0 as! Double
                                    var longitude = 0.0 as! Double
                     
                                    for result in coordinates{
     
                                        let coordinateDictionary = result as! NSDictionary
                                        let coordinates = coordinateDictionary["coordinates"] as! NSDictionary
                                        longitude = coordinates["longitude"]! as! Double
                                        latitude = coordinates ["latitude"]! as! Double
                                    }
                                    self.ref.child("CITY").child("\(city)").child("COORDINATES").setValue(["Longitude":longitude,"Latitude":latitude])
                                    
                                    
                                    
                                }catch{
                                    print("exception")
                                }
                            }
                            
                            dataTask.resume()
                        }catch{
                            print ("ERRRRROOOR")
                        }
     
                    }
    */
                    
                }
    func getSafetyScores(){
     
        
        self.ref.child("CITY").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
            let city = snap.key
                
                let dictionary = snap.value as? NSDictionary
                let countryID = dictionary?["CountryId"] as? String
                if (countryID != nil){
                    var url = "https://api.tugo.com/v1/travelsafe/countries/\(countryID!)"
                    let headers : HTTPHeaders = ["X-Auth-Api-Key": "crkhekpcghn5vkardynczv2q"]
                    Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
                        let infoDictionary = response.result.value as? NSDictionary
                        if(infoDictionary != nil){
                            let number = (infoDictionary?["advisoryState"]) as? Double
                           let safetyScore = (3-number!)*3.33 as Double
                            self.ref.child("CITY").child("\(city)").child("INTERESTS").updateChildValues(["Safety":safetyScore])
                            print("\(city) updated")
                        }
                    }
                }

            }
            }

        )
    }
    
    func getPlaces (placeArray : NSArray){
        
       
        
    //  getInterestScoreByName() // triposo
      //  getInterestScoreByCoordinate(city: String) // triposodan
        
       getSafetyScores() //2 TUGO API ile safety scoreları cekildi
        
        
        /*
         var url = "https://api.tugo.com/v1/travelsafe/countries"
         
         let headers : HTTPHeaders = ["X-Auth-Api-Key": "crkhekpcghn5vkardynczv2q"]
         
         Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
         }
         
         */
        
        
        // COUNTRY UPDATE
        /*
         self.ref.child("CITY").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
         for child in snapshot.children{
         let snap = child as! DataSnapshot
         let cityName = snap.key
         
         let url = "https://www.triposo.com//api/20171027/location.json?id=\(cityName)&fields=country_id&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
         
         Alamofire.request(url,method: .get).responseJSON{ response in
         let infoDictionary = (response.result.value) as? NSDictionary
         if (infoDictionary?["results"] != nil){
         let info = infoDictionary?["results"] as? NSArray
         for item in info!{
         let itemDictionary = item as? NSDictionary
         let countryName = itemDictionary?["country_id"] as! String
         
         self.ref.self.child("CITY").child("\(cityName)").updateChildValues(["Country":countryName])
         }
         
         }
         }
         
         }
         }
         )
         
         */
        ///////// COUNTRY IDLERI EKLENDI
        /*
        
        self.ref.child("CITY").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let cityName = snap.key
                self.ref.child("CITY").child("\(cityName)").observeSingleEvent(of: DataEventType.value, with: { (citySnapshot) in
                    for cityChild in citySnapshot.children{
                        let cityDictionary = (child as! DataSnapshot).value as? NSDictionary
                        let country = cityDictionary?["Country"] as? String
                    self.ref.child("CITIES").child("ZRH").observeSingleEvent(of: DataEventType.value, with: { (countrySnap) in
                        for countryChild in countrySnap.children{
                        let countryDictionary = (countryChild as! DataSnapshot).value as? NSDictionary
               let name = countryDictionary?["englishName"] as? String
                        if (country == name!){
                            self.ref.child("CITY").child("\(cityName)").updateChildValues(["CountryId" : countryDictionary?["id"]])
                           print("YES")
                        }
                    }
                    
                        })
 */
                    /*
                   // print("\(country!) : \(cityName)")
                    var url = "https://api.tugo.com/v1/travelsafe/countries"
                    
                    let headers : HTTPHeaders = ["X-Auth-Api-Key": "crkhekpcghn5vkardynczv2q"]
                    Alamofire.request(url, method: .get, headers: headers).responseJSON{ response in
                        print("City: \(cityName)")
print(response.result.value)
                        if (response.result.value != nil){
                        let countryArray = response.result.value as? NSArray
for countryItem in countryArray!{
                                let countryDictionary = countryItem as? NSDictionary
                            let name = countryDictionary?["englishName"] as! String
    print("country:  eklenicek \(name)")
                            if (country! == name){
                                self.ref.child("CITY").child("\(cityName)").updateChildValues(["CountryId" : countryDictionary?["id"]])
                                print("Country \(country!) added to \(cityName)")
                            }
                            
                        }
 
                        }
                    

 
                    }
 
                    }
 
                }
                    )
            }
        }
            )
 
 */

 
 
 
        ///////////////////////////
        places = Array()
        
        
        for place in placeArray{
                        let placeDictionary = place as! NSDictionary
            
            if (placeDictionary.count > 4){
                
                let newPlace = Place (placeId : placeDictionary["PlaceId"]! as! Int ,
                                      IataCode : placeDictionary ["IataCode"]! as! String,
                                      name : placeDictionary ["Name"]! as! String,
                                      type : placeDictionary["Type"]! as! String,
                                      code : placeDictionary["SkyscannerCode"]! as! String,
                                      cityName : placeDictionary ["CityName"]! as! String,
                                      cityId : placeDictionary["CityId"]! as! String,
                                      countryName : placeDictionary["CountryName"]! as! String
                )
                
                //    ref.child("CITIES").child("\(newPlace.IataCode)").setValue(["SkyScannerCode" : newPlace.code, "CityName" : newPlace.cityName,"CityId" : newPlace.cityId,"Country" : newPlace.countryName,"Name" : newPlace.name])
                
                (places?.append(newPlace))!
                /*
                 ref.child("CITY").child("\(newPlace.cityName!)").setValue(["Country" : newPlace.countryName,"SkyScannerCode" : newPlace.code])
                 
                 self.ref.root.child("CITY").child("\(newPlace.cityName!)").child("INTERESTS").setValue(["Art & Architecture":0,"Festival":0,"Adventure":0,"Romance":0,"Nature":0,"Night Life":0,"Beach":0,"Food and Drink":0,"Warm Weather":0,"Safety":0,"RoadTrip":0,"Shopping":0,"Winter Vacation":0])
                 
                 
                 
                 
                 
                 ref.child("AIRPORTS").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                 if( snapshot.hasChild(newPlace.cityName!)){
                 ////// BURAYI EKLEMEMIZ LAZIM!!!!!!!
                 // anı citye farklı havaalanlaır eklemek icin
                 
                 }
                 })
                 
                 ref.child("AIRPORTS").child("\(newPlace.cityName!)").setValue(["SkyScannerCode" : newPlace.code])
                 
                
                //do catche tekrar bakmak lazım
                // print(newPlace.cityName!)
                
                //update 4 of the INTEREST VALUES
                
                
                var city = "\(newPlace.cityName!)"
                                 let networkSession = URLSession.shared
                 print("hmmm")
                 var city = "\(newPlace.cityName!)"
                 
                 
                 let whitespace = NSCharacterSet.whitespaces
                 
                 let phrase = city
                 let range = phrase.rangeOfCharacter(from: whitespace)
                 
                 if let test = range {
                 print("mmmm")
                 //// bosluklu cityler icin check edilmeli
                 }else{
                 
                 
                 do{
                 
                 let coordinateURL = "https://www.triposo.com/api/20171027/location.json?id=\(city)&type=city&fields=coordinates&account=RJ1V77PU&token=dvz1fidxe66twck6qynircn6ii3o2ydg"
                 print(newPlace.cityName!)
                 
                 
                 var req = URLRequest(url: URL(string: coordinateURL)!)
                 req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                 let dataTask = networkSession.dataTask(with: req) {(data,response,error) in
                 
                 let jsonReadable = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                 
                 do{
                 
                 
                 let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                 
                 let coordinates = jsonDictionary["results"] as! NSArray
                 var latitude = 0.0 as! Double
                 var longitude = 0.0 as! Double
                 print(city)
                 
                 for result in coordinates{
                 
                 let coordinateDictionary = result as! NSDictionary
                 let coordinates = coordinateDictionary["coordinates"] as! NSDictionary
                 longitude = coordinates["longitude"]! as! Double
                 latitude = coordinates ["latitude"]! as! Double
                 }
                 self.ref.child("CITY").child("\(city)").child("COORDINATES").setValue(["Longitude":longitude,"Latitude":latitude])
                 
                 
                 
                 }catch{
                 print("exception")
                 }
                 }
                 
                 dataTask.resume()
                 }catch{
                 print ("ERRRRROOOR")
                 }
                 }
                */
                 //  */
                
                
                
                
            }
        }
        
    }
    
    
    func getCarriers(carrierArray : NSArray){
        carriers = Array()
        for carrier in carrierArray{
            let carrierDictionary = carrier as! NSDictionary
            
            let newCarrier = Carrier(id : carrierDictionary["CarrierId"]! as! Int , name: carrierDictionary["Name"]! as! String)
            
            carriers?.append(newCarrier)
        }
    }
    
    func getCurrencies (currencyArray : NSArray){
        currencies = Array()
    }
    
    
    func loadCityList(){
        for dest in sortedArray!{
            let new = dest as! NSDictionary
        }
    }
}
