//
//  WeatherLogger.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/26.
//

import Foundation
import os

class WeatherLogger: NSObject {
    
    static let instance = WeatherLogger()
    
    let logger = Logger(subsystem: "connie.NiceWeather", category: "NiceWeather")
}
