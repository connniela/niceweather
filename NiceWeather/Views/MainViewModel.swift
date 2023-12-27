//
//  MainViewModel.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/7.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var weather: WeatherData?
    
    private var locationSubscription: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupLoaction()
        setupBindings()
    }
    
    private func setupBindings() {
        WeatherManager.instance.$weather
            .assign(to: \.weather, on: self)
            .store(in: &cancellables)
    }
    
    private func setupLoaction() {
        locationSubscription = LocationManager.instance.location().sink { [weak self] location in
            if LocationManager.instance.lat > 0 && LocationManager.instance.lon > 0 {
                self?.getWeather()
            }
        }
    }
    
    func getWeather() {
        WeatherManager.instance.getWeather()
    }
}
