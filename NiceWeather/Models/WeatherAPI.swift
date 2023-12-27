//
//  WeatherAPI.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/8.
//

import Foundation
import Combine

struct API {
    static let apiKey = "APIKey"
    static let baseUrl = "https://api.openweathermap.org"
    static let iconUrl = "https://openweathermap.org"
}

struct WeatherAPI {
    
    enum APIEndPoint {
        case weather(cityName: String?, stateCode: String?, countryCode: String?)
        case forecast(cityName: String?, stateCode: String?, countryCode: String?)
        case direct(cityName: String)
    }
    
    static func fetchWeather(cityName: String? = nil, stateCode: String? = nil, countryCode: String? = nil) -> AnyPublisher<WeatherData, Error> {
        let url = APIEndPoint.weather(cityName: cityName, stateCode: stateCode, countryCode: countryCode).url
        WeatherLogger.instance.logger.info("url: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchForecast(cityName: String? = nil, stateCode: String? = nil, countryCode: String? = nil) -> AnyPublisher<ForecastData, Error> {
        let url = APIEndPoint.forecast(cityName: cityName, stateCode: stateCode, countryCode: countryCode).url
        WeatherLogger.instance.logger.info("url: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ForecastData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchDirects(cityName: String) -> AnyPublisher<[DirectData], Error> {
        let url = APIEndPoint.direct(cityName: cityName).url
        WeatherLogger.instance.logger.info("url: \(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [DirectData].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension WeatherAPI.APIEndPoint {
    
    var url: URL {
        var urlComponents = URLComponents(string: API.baseUrl)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
           fatalError("Invalid URL")
        }
        return url
    }
    
    var path: String {
       switch self {
       case .weather:
          return "/data/2.5/weather"
       case .forecast:
          return "/data/2.5/forecast"
       case .direct:
          return "/geo/1.0/direct"
       }
    }
    
    var queryItems: [URLQueryItem]? {
        let items = [
            URLQueryItem(name: "appid", value: API.apiKey),
            URLQueryItem(name: "units", value: "metric"),
         ]
        
        func geocodingItem(cityName: String?, stateCode: String?, countryCode: String?) -> String {
            var qString: String = ""
            if let cityName = cityName {
                qString.append(cityName)
            }
            if let stateCode = stateCode {
                if !qString.isEmpty {
                    qString.append(",")
                }
                qString.append(stateCode)
            }
            if let countryCode = countryCode {
                if !qString.isEmpty {
                    qString.append(",")
                }
                qString.append(countryCode)
            }
            return qString
        }
        
        switch self {
        case .weather(let cityName, let stateCode, let countryCode):
            let qString: String = geocodingItem(cityName: cityName, stateCode: stateCode, countryCode: countryCode)
            if qString.isEmpty {
                return items + [
                    URLQueryItem(name: "lat", value: "\(LocationManager.instance.lat)"),
                    URLQueryItem(name: "lon", value: "\(LocationManager.instance.lon)"),
                ]
            }
            else {
                return items + [
                    URLQueryItem(name: "q", value: qString),
                ]
            }
        case .forecast(let cityName, let stateCode, let countryCode):
            let qString: String = geocodingItem(cityName: cityName, stateCode: stateCode, countryCode: countryCode)
            if qString.isEmpty {
                return items + [
                    URLQueryItem(name: "lat", value: "\(LocationManager.instance.lat)"),
                    URLQueryItem(name: "lon", value: "\(LocationManager.instance.lon)"),
                    URLQueryItem(name: "cnt", value: "40"),
                ]
            }
            else {
                return items + [
                    URLQueryItem(name: "q", value: qString),
                    URLQueryItem(name: "cnt", value: "40"),
                ]
            }
        case .direct(let cityName):
            return [
                URLQueryItem(name: "appid", value: API.apiKey),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "q", value: cityName),
            ]
        }
    }
}
