//
//  SearchCityView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/25.
//

import SwiftUI

struct SearchCityView: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SearchCityViewModel
    
    init(saveAction: @escaping (DirectData) -> ()) {
        let searchCityViewModel = SearchCityViewModel(saveAction: saveAction)
        _viewModel = StateObject(wrappedValue: searchCityViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    if let directs = viewModel.directs {
                        ForEach(directs, id: \.lat) { direct in
                            Button {
                                dismiss()
                                viewModel.save(direct: direct)
                                
                                WeatherManager.instance.getWeather(cityName: direct.name, stateCode: direct.state, countryCode: direct.country)
                                WeatherManager.instance.getForecast(cityName: direct.name, stateCode: direct.state, countryCode: direct.country)
                                
                            } label: {
                                SearchCityRow(direct: direct)
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: nil
        )
        .onSubmit(of: .search) {
            viewModel.getDirects {
               dismissSearch()
            }
        }
    }
}

fileprivate struct SearchCityRow: View {
    let direct: DirectData
    
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .foregroundStyle(.thinMaterial)
        )
    }
    
    private func countryName(for countryCode: String) -> String? {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: countryCode)
    }
}

#Preview {
    SearchCityView { _ in }
}
