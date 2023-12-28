//
//  SidebarViewModel.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/25.
//

import Foundation
import Combine

class SidebarViewModel: ObservableObject {
    @Published var myDirects: [DirectData]?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        getMyDirects()
    }
    
    func getMyDirects() {
        UserDefaults.standard.getMyDirects { directs in
            if directs != nil {
                self.myDirects = directs
            }
            
            UserDefaults.standard.publisher(for: \.myDirectJsonStrings)
                .compactMap { $0 }
                .map { jsonStrings in
                    jsonStrings.compactMap { jsonString in
                        guard let data = jsonString.data(using: .utf8),
                              let directData = try? JSONDecoder().decode(DirectData.self, from: data) else {
                            return nil
                        }
                        return directData
                    }
                }
                .assign(to: &$myDirects)
        }
    }
    
    func versionText() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        return String(format: "Version %@.%@", version ?? "", build ?? "")
    }
}

extension UserDefaults {
    
    static let MyDirectsDataKey: String = "MyDirectsData"
    
    @objc dynamic var myDirectJsonStrings: [String]? {
        return array(forKey: UserDefaults.MyDirectsDataKey) as? [String]
    }
    
    func getMyDirects(callback: (([DirectData]?) -> Void)) {
        if let myDirectJsonStrings = myDirectJsonStrings {
            var directs: [DirectData] = []
            for jsonString in myDirectJsonStrings {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let decodedDirect = try jsonDecoder.decode(DirectData.self, from: jsonData)
                        directs.append(decodedDirect)
                    }
                    catch {
                        WeatherLogger.instance.logger.error("❗JSON decoding error: \(error.localizedDescription)")
                    }
                }
            }
            
            callback(directs)
        }
        else {
            callback(nil)
        }
    }
    
    func addMyDirect(data: DirectData) {
        var myDirectJsonStrings = myDirectJsonStrings ?? []
        
        for jsonString in myDirectJsonStrings {
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedDirect = try jsonDecoder.decode(DirectData.self, from: jsonData)
                    if decodedDirect.name == data.name && decodedDirect.lat == data.lat && decodedDirect.lon == data.lon {
                        return
                    }
                }
                catch {
                    WeatherLogger.instance.logger.error("❗JSON decoding error: \(error.localizedDescription)")
                }
            }
        }
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                myDirectJsonStrings.append(jsonString)
                UserDefaults.standard.set(myDirectJsonStrings, forKey: UserDefaults.MyDirectsDataKey)
            }
        }
        catch {
            WeatherLogger.instance.logger.error("❗JSON encoding error: \(error.localizedDescription)")
        }
    }
    
    func deleteMyDirect(data: DirectData, callback: (([DirectData]) -> Void)) {
        let myDirectJsonStrings = myDirectJsonStrings ?? []
        
        var newMyDirectJsonStrings: [String] = []
        var directs: [DirectData] = []
        for jsonString in myDirectJsonStrings {
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedDirect = try jsonDecoder.decode(DirectData.self, from: jsonData)
                    if decodedDirect.name != data.name || decodedDirect.lat != data.lat || decodedDirect.lon != data.lon {
                        newMyDirectJsonStrings.append(jsonString)
                        directs.append(decodedDirect)
                    }
                }
                catch {
                    WeatherLogger.instance.logger.error("❗JSON decoding error: \(error.localizedDescription)")
                }
            }
        }
        
        UserDefaults.standard.set(newMyDirectJsonStrings, forKey: UserDefaults.MyDirectsDataKey)
        callback(directs)
    }
}
