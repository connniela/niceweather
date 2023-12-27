//
//  WeatherData.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/8.
//

import Foundation

struct WeatherData: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    
    static let example = WeatherData(coord: Coord.example, weather: [Weather.example], main: Main.example, visibility: 10000, wind: Wind.example, clouds: Clouds.example, dt: 1661870592, sys: Sys.example, timezone: 7200, id: 3163858, name: "Zocca")
    
    struct Coord: Codable {
        var lon: Double?
        var lat: Double?
        
        static let example = Coord(lon: 10.99, lat: 44.34)
    }

    struct Weather: Codable {
        var description: String?
        var icon: String?
        
        static let example = Weather(description: "moderate rain", icon: "10d")
    }

    struct Main: Codable {
        var temp: Double?
        var feels_like: Double?
        var humidity: Int?
        var temp_min: Double?
        var temp_max: Double?
        
        static let example = Main(temp: 35, feels_like: 38, humidity: 64, temp_min: 12, temp_max: 35)
    }

    struct Wind: Codable {
        var speed: Double?
        
        static let example = Wind(speed: 0.62)
    }
    
    struct Clouds: Codable {
        var all: Int?
        
        static let example = Clouds(all: 100)
    }

    struct Sys: Codable {
        var sunrise: Int?
        var sunset: Int?
        
        static let example = Sys(sunrise: 1661834187, sunset: 1661882248)
    }
}
