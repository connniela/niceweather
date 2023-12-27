//
//  ForecastData.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/12.
//

import Foundation

struct ForecastData: Codable {
    var list: [List]?
    var city: City?
    
    static let example = ForecastData(list: [List(dt: 1661870592, main: WeatherData.Main.example, weather: [WeatherData.Weather.example], wind: WeatherData.Wind.example, pop: 0.53, sys: Sys.example)], city: City.example)
    
    struct List: Codable {
        var dt: Int?
        var main: WeatherData.Main?
        var weather: [WeatherData.Weather]?
        var wind: WeatherData.Wind?
        var visibility: Int?
        var pop: Double?
        var sys: Sys?
    }
    
    struct Sys: Codable {
        var pod: String? // n - night, d - day
        
        static let example = Sys(pod: "d")
    }
    
    struct City: Codable {
        var id: Int?
        var name: String?
        var coord: WeatherData.Coord?
        var timezone: Int?
        var sunrise: Int?
        var sunset: Int?
        
        static let example = City(id: 3163858, name: "Zocca", coord: WeatherData.Coord.example, timezone: 7200, sunrise: 1661834187, sunset: 1661882248)
    }
}
