//
//  WeatherDetailView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/21.
//

import SwiftUI

struct WeatherDetailView: View {
    let weather: WeatherData
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10, alignment: .center),
            GridItem(.flexible(), spacing: 10, alignment: .center)]) {
                WeatherDetailItem(label: Label("Sunrise", systemImage: "sunrise")) {
                    Text(timeFormate(weather.sys?.sunrise, timezone: weather.timezone))
                }
                
                WeatherDetailItem(label: Label("Sunset", systemImage: "sunset")) {
                    Text(timeFormate(weather.sys?.sunset, timezone: weather.timezone))
                }
                
                WeatherDetailItem(label: Label("Clouds", systemImage: "cloud")) {
                    Text(cloudsFormate(weather.clouds?.all))
                }
                
                WeatherDetailItem(label: Label("Wind", systemImage: "wind")) {
                    Text(speedFormate(weather.wind?.speed))
                }
                
                WeatherDetailItem(label: Label("Humidity", systemImage: "humidity")) {
                    Text(humidityFormate(weather.main?.humidity))
                }
                
                WeatherDetailItem(label: Label("Visibility", systemImage: "eye")) {
                    Text(visibilityFormate(weather.visibility))
                }
            }
    }
}

extension WeatherDetailView {
    private func cloudsFormate(_ value: Int?) -> String {
        guard let value = value else { return "" }
        let string = String(format: "%d %%", value)
        return string
    }
    
    private func humidityFormate(_ value: Int?) -> String {
        guard let value = value else { return "" }
        let string = String(format: "%d %%", value)
        return string
    }
    
    private func speedFormate(_ value: Double?) -> String {
        guard let value = value else { return "" }
        let string = String(format: "%.1f m/s", value)
        return string
    }
    
    private func visibilityFormate(_ value: Int?) -> String {
        guard let value = value else { return "" }
        let string = String(format: "%.1f km", Double(value) / 1000)
        return string
    }
    
    private func timeFormate(_ dt: Int?, timezone: Int?) -> String {
        guard let dt = dt, let timezone = timezone else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        
        return formatter.string(from: date)
    }
}

fileprivate struct WeatherDetailItem<Content: View>: View {
    
    private let label: Label<Text, Image>
    private let content: Content
    
    init(label: Label<Text, Image>, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            label
                .font(.system(.callout, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content
        }
        .font(.system(.title2, design: .rounded))
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thickMaterial).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/))
    }
    
}

#Preview {
    WeatherDetailView(weather: WeatherData.example)
        .background(.gray)
}
