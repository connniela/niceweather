//
//  CurrentWeatherView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/10.
//

import SwiftUI

struct CurrentWeatherView: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(alignment: .center, spacing: nil) {
            Text(dateFormate(weather.dt, timezone: weather.timezone))
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
            
            HStack {
                WeatherIconView(icon: weather.weather?.first?.icon)
                    .frame(maxWidth: .infinity)
                
                Text(tempFormate(weather.main?.temp))
                   .font(.system(size: 60, weight: .medium, design: .rounded))
                   .frame(maxWidth: .infinity)
            }
            
            HStack {
                Text(weather.weather?.first?.description?.capitalized ?? "")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
                
                Label {
                    Text(tempFormate(weather.main?.feels_like))
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                } icon: {
                   Image(systemName: "person")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.gray, .gray)
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity)
            }
            
            Label {
                Text(String(format: "%@ ~ %@", tempFormate(weather.main?.temp_min), tempFormate(weather.main?.temp_max)))
            } icon: {
                Image(systemName: "thermometer")
                   .symbolRenderingMode(.palette)
                   .symbolVariant(.fill)
                   .foregroundStyle(.primary, .red)
            }
            .padding(8)
        }
    }
}
    
extension CurrentWeatherView {
    private func dateFormate(_ dt: Int?, timezone: Int?) -> String {
        guard let dt = dt, let timezone = timezone else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        
        return formatter.string(from: date)
    }
    
    private func tempFormate(_ temp: Double?) -> String {
        guard let temp = temp else { return "" }
        let tempString = String(format: "%.1f°", temp)
        return tempString
    }
}

#Preview {
    CurrentWeatherView(weather: WeatherData.example)
        .background(.gray)
}
