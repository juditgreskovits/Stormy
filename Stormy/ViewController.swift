//
//  ViewController.swift
//  Stormy
//
//  Created by Judit Greskovits on 09/10/2014.
//  Copyright (c) 2014 Judit Greskovits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = "6da82739c588a45ea214840c076f3aef";

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseURL)
        // let weatherData = NSData.dataWithContentsOfURL(forecastURL, options: nil, error: nil)
        // println(weatherData)
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask:NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: {(location: NSURL!, response: NSURLResponse!, error: NSError!)-> Void in
            
            if (error == nil) {
            
                // var urlContents = NSString.stringWithContentsOfURL(location, encoding: NSUTF8StringEncoding, error: nil)
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                
                let currentWeatherDictionary: NSDictionary = weatherDictionary["currenlty"] as NSDictionary
                // println(urlContents)
            }
        })
        downloadTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

