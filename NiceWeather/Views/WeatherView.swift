//
//  WeatherView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/10.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    
    let weather: WeatherData
    @Binding var isSidebarShowing: Bool
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    List {
                        Section {
                            CurrentWeatherView(weather: weather)
                        }
                        .listRowBackground(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundStyle(.thickMaterial).opacity(0.8))
                        
                        if let forecast = viewModel.forecast {
                            Section {
                                ForecastWeatherView(forecast: forecast)
                            }
                            .listRowBackground(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundStyle(.thickMaterial).opacity(0.8))
                        }
                        
                        Section {
                            WeatherDetailView(weather: weather)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundStyle(.thickMaterial).opacity(0))
                    }
                    .scrollContentBackground(.hidden)
                }
                .navigationBarItems(leading: Button(action: {
                    isSidebarShowing.toggle()
                }) {
                    Image(systemName: "sidebar.leading")
                })
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(weather.name ?? "")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .toolbarBackground(Color("blueBackground"), for: .navigationBar)
            }
        }
    }
}

struct NavigationBarTitleModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
    }
}

#Preview {
    WeatherView(weather: WeatherData.example, isSidebarShowing: .constant(false))
}
