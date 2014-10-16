//
//  Current.swift
//  Stormy
//
//  Created by Judit Greskovits on 09/10/2014.
//  Copyright (c) 2014 Judit Greskovits. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    
    init(weatherDictionary: NSDictionary) {
        let currentWeatherDictionary: NSDictionary = weatherDictionary["currently"] as NSDictionary
        
        temperature = currentWeatherDictionary["temperature"] as Int
        humidity = currentWeatherDictionary["humidity"] as Double
        precipProbability = currentWeatherDictionary["precipProbability"] as Double
        summary = currentWeatherDictionary["summary"] as String
        
        let currentTimeIntValue = currentWeatherDictionary["time"] as Int
        currentTime = dateStringFromUnixTime(currentTimeIntValue)
        
        let iconString = currentWeatherDictionary["icon"] as String
        icon = weatherIconFromString(iconString)
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        var iconImage = UIImage(named: imageName)
        return iconImage
    }
    
}
