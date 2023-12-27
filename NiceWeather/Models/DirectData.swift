//
//  DirectData.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/22.
//

import Foundation

struct DirectData: Codable {
    var name: String?
    var local_names: Dictionary<String, String>?
    var lon: Double?
    var lat: Double?
    var country: String?
    var state: String?
}
