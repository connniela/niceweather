//
//  SidebarView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/25.
//

import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel = SidebarViewModel()
    
    @Binding var isShowing: Bool
    @Binding var isSearchViewShowing: Bool
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isShowing ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isShowing)
            .onTapGesture {
                isShowing.toggle()
            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                BackgroundView()
                
                VStack(alignment: .leading, spacing: 20) {
                    Button {
                        isShowing.toggle()
                        isSearchViewShowing.toggle()
                    } label: {
                        Label("Search City", systemImage: "magnifyingglass")
                            .font(.system(.title3, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    
                    Button {
                        WeatherManager.instance.getWeather()
                        WeatherManager.instance.getForecast()
                        isShowing.toggle()
                    } label: {
                        Label(WeatherManager.instance.currentCityName ?? "Current", systemImage: "location.fill")
                            .font(.system(.title3, design: .rounded))
                            .bold()
                    }
                    .foregroundStyle(.primary)
                    
                    List {
                        Section {
                            if let myDirects = viewModel.myDirects {
                                ForEach(myDirects, id: \.lat) { direct in
                                    MyDirectRow(direct: direct) { direct in
                                        UserDefaults.standard.deleteMyDirect(data: direct) { directs in
                                            viewModel.myDirects = directs
                                        }
                                    }
                                    .onTapGesture {
                                        WeatherManager.instance.getWeather(cityName: direct.name, stateCode: direct.state, countryCode: direct.country)
                                        WeatherManager.instance.getForecast(cityName: direct.name, stateCode: direct.state, countryCode: direct.country)
                                        isShowing.toggle()
                                    }
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundStyle(.thickMaterial).opacity(0))
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                }
                .padding(.top, 80)
                .padding(.horizontal, 40)
            }
            .frame(width: sideBarWidth)
            .offset(x: isShowing ? 0 : -sideBarWidth)
            .animation(.default, value: isShowing)
            
            Spacer()
        }
    }
}

fileprivate struct MyDirectRow: View {
    let direct: DirectData
    let deleteAction: (DirectData) -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Group {
                if let state = direct.state {
                    Text("\(direct.name ?? ""), \(state)")
                        .bold()
                        .lineLimit(1)
                }
                else {
                    Text("\(direct.name ?? "")")
                        .bold()
                }
            }
            .font(.system(.title3, design: .rounded))
            
            if let country = direct.country {
                Text(countryName(for: country) ?? "")
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
           Button(role: .destructive) {
              deleteAction(direct)
           } label: {
              Label("Delete", systemImage: "trash")
           }
        }
    }
    
    private func countryName(for countryCode: String) -> String? {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: countryCode)
    }
}

#Preview {
    SidebarView(isShowing: .constant(true), isSearchViewShowing: .constant(false))
}
