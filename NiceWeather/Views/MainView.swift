//
//  ContentView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/7.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    @State private var isSidebarShowing = false
    @State private var isSearchViewShowing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                if let weather = viewModel.weather {
                    WeatherView(weather: weather, isSidebarShowing: $isSidebarShowing)
                }
                else {
                    VStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .imageScale(.large)
                            .foregroundStyle(.secondary)
                        Text("Loading...")
                            .font(.system(.title3, design: .rounded))
                    }
                }
            }
        }
        .overlay(
            SidebarView(isShowing: $isSidebarShowing, isSearchViewShowing: $isSearchViewShowing)
        )
        .sheet(isPresented: $isSearchViewShowing, onDismiss: nil) {
            SearchCityView(saveAction: UserDefaults.standard.addMyDirect(data:))
        }
    }
}

#Preview {
    MainView()
}
