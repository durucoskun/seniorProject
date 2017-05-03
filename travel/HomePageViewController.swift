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

class HomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapKitView: MKMapView!
    let citydata = CityDataSource()
    var location = CLLocation()
    var currentCityName: String!
    @IBOutlet weak var departureLocation: UITextField!
    
    @IBOutlet weak var departureDate: UIDatePicker!
    @IBOutlet weak var returnDate: UIDatePicker!
    @IBOutlet weak var maxPrice: UITextField!
    @IBAction func locationButton(_ sender: Any) {
        if self.currentCityName != nil {
        self.departureLocation.text = self.currentCityName
        }
    }
    
    let manager = CLLocationManager()
    
    @IBAction func go(_ sender: UIButton) {
        var url = "http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/DE/EUR/en-US/\(departureLocation.text!)/anywhere/2017-05-11/2017-05-14?apiKey=at812187236421337946364002643367"
        citydata.loadCities(url: url, code: departureLocation.text!)
        
        //   citydata.loadCities(url: "http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/DE/EUR/en-US/IST/anywhere/2017-05-01/2017-05-04?apiKey=at812187236421337946364002643367", code: IST)
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
                    if place.administrativeArea! == "Istanbul"{
                        if self.currentCityName == nil{
                            self.currentCityName = "IST"
                            self.departureLocation.text = self.currentCityName
                        }
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
            
        }
        
        
     }
    
    
}
