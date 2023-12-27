//
//  WeatherIconView.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/14.
//

import SwiftUI

struct WeatherIconView: View {
    @StateObject private var imageService = URLImageService()
    
    private let icon: String?
    private let height: Int
    private let width: Int
    
    init(icon: String?, height: Int = 50, width: Int = 50) {
        self.icon = icon
        self.height = height
        self.width = width
    }
    
    var body: some View {
        Group {
            if let image = imageService.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(width), height: CGFloat(height))
            }
            else {
                ProgressView()
            }
        }
        .onAppear {
            imageService.loadImage(from: iconUrl(icon))
        }
        .onDisappear {
            imageService.cancel()
        }
    }
    
    private func iconUrl(_ icon: String?) -> URL {
        var urlComponents = URLComponents(string: API.iconUrl)
        urlComponents?.path = "/img/wn/\(icon ?? "01d")@2x.png"
        guard let url = urlComponents?.url else {
            fatalError("Invalid URL")
        }
        return url
    }
}

#Preview {
    WeatherIconView(icon: "01d")
}
