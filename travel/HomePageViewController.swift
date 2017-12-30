//
//  HomePageViewController.swift
//  travel
//
//  Created by Ata Aygen on 13/04/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class HomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ref = Database.database().reference()
    
    @IBOutlet weak var mapKitView: MKMapView!
    let citydata = CityDataSource()
    var location = CLLocation()
    var currentCityName: String!
    var currency: String = ""
    var cityCode : String = ""
    var userUid : String!
    @IBOutlet weak var departureLocation: UITextField!
    
    @IBOutlet weak var departureDate: UIDatePicker!
    @IBOutlet weak var returnDate: UIDatePicker!
    @IBOutlet weak var maxPrice: UITextField!
    @IBAction func locationButton(_ sender: Any) {
        if self.currentCityName != nil {
            self.departureLocation.text = self.currentCityName
        }
    }
    @IBOutlet weak var currencyPicker: UISegmentedControl!
    
    let manager = CLLocationManager()
    
    
    
    @IBAction func go(_ sender: UIButton) {
      //  let vc = self.appDelegate.getCurrentViewController()
        let vc = self as! HomePageViewController
        
        goAction: do{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var departure = dateFormatter.string(from: departureDate.date)
            var returnD = dateFormatter.string(from: returnDate.date)
            var timeDiff = DateComponents()
            timeDiff.hour = -3
            timeDiff.minute = -1
            let correctCurrDate = Calendar.current.date(byAdding: timeDiff, to: Date())!
            
            print(departureDate.date)
            print(Date())
            if(departureDate.date<correctCurrDate){
                let alert = UIAlertController(title: "Oops!", message: "Departure date cannot be before current date", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated:true,completion:nil)
                break goAction
            }
            
            if(departureDate.date>=returnDate.date){
                let alert = UIAlertController(title: "Oops!", message: "Departure date cannot be later than/the same as return date", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated:true,completion:nil)
                break goAction
            }
            if(departureLocation.text==""){
                let alert = UIAlertController(title: "Oops!", message: "Departure location cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated:true,completion:nil)
                break goAction
            }
            if(maxPrice.text==""){
                let alert = UIAlertController(title: "Oops!", message: "Maximum price cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated:true,completion:nil)
                break goAction
            }
            
            if currencyPicker.selectedSegmentIndex==0{
                currency = "TRY"
            }
            else if currencyPicker.selectedSegmentIndex==1{
                currency = "USD"
            }
            else if currencyPicker.selectedSegmentIndex==2{
                currency = "EUR"
            }
            
            var departureAirport: String = ""
            var url : String = ""
            
            
            
            ref.child("AIRPORTS").observeSingleEvent(of: .value, with: { (snapshot) in
                
                departureAirport = snapshot.childSnapshot(forPath: "\(self.departureLocation.text!)").children.nextObject().debugDescription
                let rng = departureAirport.index(departureAirport.startIndex, offsetBy: 31)..<departureAirport.index(departureAirport.endIndex, offsetBy: -1)
                departureAirport = departureAirport.substring(with: rng)
                print(departureAirport)
               
               //url = "http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/TR/\(self.currency)/en-US/\(departureAirport)/anywhere/\(departure)/\(returnD)?apiKey=at812187236421337946364002643367"
                url = "http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/TR/TRY/en-US/\(departureAirport)/anywhere/anytime//anytime?apiKey=at812187236421337946364002643367"
               
                
                print(url)
          
                self.citydata.loadCities(url: url, code: departureAirport, vc: vc, uid: self.userUid, price: Int(self.maxPrice.text!)!)
            })
        }
    }
    
    func goToNextView() {
        performSegue(withIdentifier: "showList", sender: self)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapKitView.setRegion(region, animated: true)
        
        self.mapKitView.showsUserLocation = true
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else{
                if let place = placemark?[0]{
                    if self.currentCityName == nil{
                        self.currentCityName = place.administrativeArea!
                        self.departureLocation.text = self.currentCityName
                    }
                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.view.backgroundColor = UIColor (patternImage:UIImage(named : "travelling-1.png")!)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if  let nextView = segue.destination as? CityViewController{
            nextView.cityDataSource = citydata
            nextView.currency = currency
            nextView.userUid = self.userUid
            
        }
        
        
    }
    
    
}
