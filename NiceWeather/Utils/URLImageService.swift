//
//  URLImageService.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/21.
//

import SwiftUI

class URLImageService: ObservableObject {
    @Published var image: UIImage?

    private var task: URLSessionDataTask?

    func loadImage(from url: URL) {
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}
