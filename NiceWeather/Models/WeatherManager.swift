//
//  WeatherManager.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/7.
//

import Foundation
import Combine

class WeatherManager {
    
    static let instance = WeatherManager()
    
    @Published var weather: WeatherData?
    @Published var forecast: ForecastData?
    @Published var directs: [DirectData]?
    
    var currentCityName: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getWeather(cityName: String? = nil, stateCode: String? = nil, countryCode: String? = nil) {
        WeatherAPI.fetchWeather(cityName: cityName, stateCode: stateCode, countryCode: countryCode)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    WeatherLogger.instance.logger.error("❗fetch weather error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] weather in
                self?.weather = weather
                if cityName == nil {
                    self?.currentCityName = weather.name
                }
            }
            .store(in: &cancellables)
    }
    
    func getForecast(cityName: String? = nil, stateCode: String? = nil, countryCode: String? = nil) {
        WeatherAPI.fetchForecast(cityName: cityName, stateCode: stateCode, countryCode: countryCode)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    WeatherLogger.instance.logger.error("❗fetch forecast error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] forecast in
                self?.forecast = forecast
            }
            .store(in: &cancellables)
    }
    
    func getDirects(cityName: String) {
        WeatherAPI.fetchDirects(cityName: cityName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    WeatherLogger.instance.logger.error("❗fetch directs error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] directs in
                var uniqueDirects: [String: DirectData] = [:]

                for direct in directs {
                    let key = "\(direct.name ?? "")-\(direct.lat ?? 0)-\(direct.lon ?? 0)"
                    uniqueDirects[key] = direct
                }
                
                self?.directs = Array(uniqueDirects.values)
            }
            .store(in: &cancellables)
    }
}
