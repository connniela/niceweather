//
//  WeatherViewModel.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/12.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var forecast: ForecastData?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupBindings()
        if WeatherManager.instance.forecast == nil {
            getForecast()
        }
    }
    
    private func setupBindings() {
        WeatherManager.instance.$forecast
            .assign(to: \.forecast, on: self)
            .store(in: &cancellables)
    }
    
    func getForecast() {
        WeatherManager.instance.getForecast()
    }
}
