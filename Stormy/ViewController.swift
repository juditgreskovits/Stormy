//
//  ViewController.swift
//  Stormy
//
//  Created by Judit Greskovits on 09/10/2014.
//  Copyright (c) 2014 Judit Greskovits. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    private let apiKey = "6da82739c588a45ea214840c076f3aef"
    private let baseURL = "https://api.forecast.io/forecast/"
    
    let locationManager = CLLocationManager()
    
    let authorizationErrorMessage = "Without accessing your location the app can't tell give you weather info."
    let networkErrorMessage = "Unable to load data. Connectivity error!"
    let locationErrorMessage = "Unable to access your location."

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh() {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let authorized = status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.Authorized
        println(authorized)
        if(authorized) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location: CLLocation = locations[0] as CLLocation
        let coordinate: CLLocationCoordinate2D = location.coordinate
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if(error == nil) {
                if (placemarks.count > 0) {
                    let placemark = placemarks[0] as CLPlacemark
                    self.locationLabel.text = "\(placemark.subLocality), \(placemark.locality)"
                    self.getCurrentWeatherData(coordinate.latitude, longitude: coordinate.longitude)
                } else {
                    self.handleErrorWithMessage(self.locationErrorMessage)
                }
            } else {
                self.handleErrorWithMessage(self.locationErrorMessage)
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        handleErrorWithMessage(locationErrorMessage)
    }
    
    func getCurrentWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let relativeToURL = NSURL(string: "\(baseURL)\(apiKey)/")
        let forecastURL = NSURL(string: "\(latitude),\(longitude)?units=uk", relativeToURL: relativeToURL)
        // let weatherData = NSData.dataWithContentsOfURL(forecastURL, options: nil, error: nil)
        // println(weatherData)
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask:NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: {(location: NSURL!, response: NSURLResponse!, error: NSError!)-> Void in
            
            if (error == nil) {
                
                // var urlContents = NSString.stringWithContentsOfURL(location, encoding: NSUTF8StringEncoding, error: nil)
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.updateView(currentWeather)
                    
                    self.resetRefresh()
                    
                })
            } else {
                
                self.handleErrorWithMessage(self.networkErrorMessage)
                
                self.resetRefresh()
            }
        })
        downloadTask.resume()
    }
    
    func updateView(currentWeather: Current) {
        iconView.image = currentWeather.icon!
        currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
        temperatureLabel.text = "\(currentWeather.temperature)"
        humidityLabel.text = "\(currentWeather.humidity)"
        precipitationLabel.text = "\(currentWeather.precipProbability)"
        summaryLabel.text = currentWeather.summary
    }
    
    func resetRefresh() {
        refreshActivityIndicator.stopAnimating()
        refreshActivityIndicator.hidden = true
        refreshButton.hidden = false
    }
    
    func handleErrorWithMessage(message: String) {
        let networkIssueController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkIssueController.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueController.addAction(cancelButton)
        
        presentViewController(networkIssueController, animated: true, completion: nil)
    }
}

