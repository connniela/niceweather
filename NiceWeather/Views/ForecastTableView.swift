//
//  ForecastTableView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/21.
//

import SwiftUI

struct ForecastTableView: View {
    let forecast: ForecastData
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                List {
                    Section {
                        if let list = forecast.list, let city = forecast.city {
                            ForEach(list, id: \.dt) { list in
                                ForecastCell(list: list, city: city)
                            }
                        }
                    }
                    .listRowBackground(RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .foregroundStyle(.thickMaterial).opacity(0))
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("FORECAST")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .toolbarBackground(Color("blueBackground"), for: .navigationBar)
        }
    }
}

fileprivate struct ForecastCell: View {
    let list: ForecastData.List
    let city: ForecastData.City
    
    var body: some View {
        ZStack {
            if list.sys?.pod == "n" {
                ZStack {
                   
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.5))
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text(timeFormate(list.dt, timezone:city.timezone))
                    .font(.system(.body, design: .rounded))
                
                Spacer()
                
                WeatherIconView(icon: list.weather?.first?.icon, height: 40, width: 40)
                
                Spacer()
                
                Text(tempFormate(list.main?.temp))
                   .font(.system(.headline, design: .rounded))
                
                Spacer()
                
                rainView
            }
        }
    }
    
    private func timeFormate(_ dt: Int?, timezone: Int?) -> String {
        guard let dt = dt, let timezone = timezone else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd E h:mm a"
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
               .padding(.leading, -16)
               .font(.system(.callout, design: .rounded))
       } icon: {
          Image(systemName: "drop")
             .symbolRenderingMode(.palette)
             .symbolVariant(.fill)
             .foregroundStyle(.blue, .white)
             .frame(width: 20, height: 20)
       }
    }
}

#Preview {
    ForecastTableView(forecast: ForecastData.example)
}
