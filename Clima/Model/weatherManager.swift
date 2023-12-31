//
//  weatherManager.swift
//  Clima
//
//  Created by Aron I. Bergman on 23.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather  (_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let apiKey = "bb6604b1269d65e5e050234364f52d9b"
    
    func fetchWeather(cityName: String) {
        let city = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlForFetch = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        performRequest(with: urlForFetch)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlForFetch = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&lat=\(latitude)&lon=\(longitute)"
        
        performRequest(with: urlForFetch)
    }
    
    var delegate: WeatherManagerDelegate?
    
    func performRequest(with urlString: String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            // 2. Create session with configuration
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("❌: \(error!)")
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWeather(weather: weather)
                        
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let temp = decoderData.main.temp
            let name = decoderData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
     return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
