//
//  SearchCityViewModel.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/25.
//

import Combine

class SearchCityViewModel: ObservableObject {
    @Published private (set) var directs: [DirectData]?
    @Published var searchText: String = ""
    
    private let saveAction: (DirectData) -> ()
    private var cancellables: Set<AnyCancellable> = []
    
    init(saveAction: @escaping (DirectData) -> ()) {
        self.saveAction = saveAction
        setupBindings()
    }
    
    private func setupBindings() {
        WeatherManager.instance.$directs
            .assign(to: \.directs, on: self)
            .store(in: &cancellables)
    }
    
    func save(direct: DirectData) {
        saveAction(direct)
    }
    
    func getDirects(completion: @escaping () -> Void) {
        guard !self.searchText.isEmpty else {
            directs?.removeAll()
            return
        }
        
        WeatherManager.instance.getDirects(cityName: searchText)
    }
}
