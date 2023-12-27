//
//  ForecastWeatherView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/12.
//

import SwiftUI

struct ForecastWeatherView: View {
    let forecast: ForecastData
    
    var body: some View {
        VStack(alignment: .leading) {
            Label("FORECAST", systemImage: "clock")
               .font(.system(.subheadline, design: .rounded))
               .foregroundStyle(.secondary)
               .padding([.top], 10)
            
            Divider()
               .background(Color.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 30) {
                   if let list = forecast.list, let city = forecast.city {
                       ForEach(list.prefix(8), id: \.dt) { list in
                           WeatherHourlyStackView(list: list, city: city)
                       }
                   }
               }
               .padding(.trailing)
            }
            .padding(.bottom, 10)
            
            Divider()
               .background(Color.primary)
            
            NavigationLink(destination: ForecastTableView(forecast: forecast)) {
                Text("View More")
                    .font(.system(.headline, design: .rounded))
                    .padding(5)
            }
        }
    }
}

fileprivate struct WeatherHourlyStackView: View {
    let list: ForecastData.List
    let city: ForecastData.City
    
    var body: some View {
       VStack(alignment: .center, spacing: 0) {
           Text(timeFormate(list.dt, timezone:city.timezone))
               .font(.system(.body, design: .rounded))
           
           Spacer()
           
           WeatherIconView(icon: list.weather?.first?.icon)
           
           Spacer()
           
           Text(tempFormate(list.main?.temp))
              .font(.system(.headline, design: .rounded))
           
           Spacer()
           
           rainView
       }
       .offset(x: 10, y: 0)
    }
    
    private func timeFormate(_ dt: Int?, timezone: Int?) -> String {
        guard let dt = dt, let timezone = timezone else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        
        return formatter.string(from: date)
    }
    
    private func tempFormate(_ temp: Double?) -> String {
        guard let temp = temp else { return "" }
        let tempString = String(format: "%.1f°", temp)
        return tempString
    }
    
    private func popFormate(_ pop: Double?) -> String {
        guard let pop = pop else { return "" }
        let popString = String(format: "%.0f%%", pop * 100)
        return popString
    }
    
    private var rainView: some View {
       Label {
           Text(popFormate(list.pop))
               .padding(.leading, -6)
       } icon: {
          Image(systemName: "drop")
             .symbolRenderingMode(.palette)
             .symbolVariant(.fill)
             .foregroundStyle(.blue, .white)
       }
       .font(.system(.callout, design: .rounded))
    }
}

#Preview {
    ForecastWeatherView(forecast: ForecastData.example)
}
